# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe Analysis::ReportSyncCommand, type: :command do
  subject do
    described_class.new(analysis_report)
  end

  let(:analysis_report) { create :analysis_report, status: :wip }
  let(:analysis_item) { create :analysis_item, :done, report: analysis_report }

  describe '#call' do
    context 'when one of the scores status is :error' do
      before do
        analysis_item.update(status: :error)
      end

      it 'expect score_report status :error' do
        subject.call

        expect(analysis_report.status).to eq('error')
      end
    end

    context 'when one of the scores status is :wip' do
      before do
        analysis_item.update(status: :wip)
      end

      it 'expects score_report status :wip' do
        subject.call

        expect(analysis_report.status).to eq('wip')
      end
    end

    context 'when one of the scores status is :todo' do
      before do
        analysis_item.update(status: :todo)
      end

      it 'expects score_report status :wip' do
        subject.call

        expect(analysis_report.status).to eq('wip')
      end
    end

    context 'when all scores status are :done' do
      before do
        analysis_item.status = :done
        analysis_item.save!
      end

      it 'expects score_report status :done' do
        subject.call

        expect(analysis_report.status).to eq('done')
      end

      xcontext 'when prediction is lower than 9.5' do # rubocop:disable RSpec/PendingWithoutReason
        # TODO: fix after creating new calculation of fee
        before do
          create :analysis_prediction, item: analysis_item, fee: 8.5
        end

        it 'sets fee to the value fee plus 2' do
          expect { subject.call }.to change(analysis_report, :fee).to(11.5)
        end
      end

      context 'when first score is approved and last is unapproved' do
        let(:analysis_item1) do
          create :analysis_item, :done, report: analysis_report
        end

        before do
          create :analysis_prediction, :approved, item: analysis_item
          create :analysis_prediction, :unapproved, item: analysis_item1
        end

        it 'updates score_report to unapproved' do
          subject.call

          expect(analysis_report.reload.approved).to be_falsey
        end
      end

      context 'when prediction is not approved' do
        before do
          create :analysis_prediction, approved: false, item: analysis_item
        end

        it 'sets score report approved to false and fee to nil' do
          subject.call

          expect(analysis_report.fee).to be_nil
          expect(analysis_report.approved).to be_falsey
        end
      end

      context 'when score was reproved by age and income validator' do
        before do
          analysis_item.update(
            disapproval_situation: :reproved_by_age_and_income
          )
        end

        it 'expects score_report status :done and reproved' do
          subject.call

          expect(analysis_report.status).to eq('done')
          expect(analysis_report.disapproval_situation).to eq(
            'reproved_by_age_and_income'
          )
        end
      end
    end

    context 'when score_report is approved' do
      before do
        analysis_report.update(approved: true)
      end

      it 'expects approved column to be true' do
        expect(analysis_report.approved).to be(true)
      end
    end

    context 'when score_report is reproved' do
      context 'when is reproved by trial' do
        before do
          analysis_item.update(disapproval_situation: :reproved_by_trial)
        end

        context 'when it has more than one score' do
          before do
            create :analysis_item, :blocked_negativity, report: analysis_report
            create :analysis_item, :debtor, report: analysis_report
            create :analysis_item, :insufficient_income, report: analysis_report
            create :analysis_item, :exceeded_debits, report: analysis_report
            create(
              :analysis_item, :reproved_by_relative, report: analysis_report
            )
          end

          it 'changes disapproval situation to reproved by trial' do
            expect do
              subject.call
            end.to change(
              analysis_report, :disapproval_situation
            ).to('reproved_by_trial')
          end
        end

        context 'when it has just one score' do
          it 'changes disapproval situation to reproved by trial' do
            expect do
              subject.call
            end.to change(
              analysis_report, :disapproval_situation
            ).to('reproved_by_trial')
          end
        end
      end

      context 'when it is not reproved by trial' do
        before do
          analysis_item.update(disapproval_situation: nil)
        end

        it 'does not change disapproval situation' do
          expect do
            subject.call
          end.not_to change(analysis_report, :disapproval_situation)
        end
      end

      context 'when approved is false' do
        before do
          analysis_report.update(approved: false)
        end

        it 'expects approved? to be false and to return' do
          expect(analysis_report.approved?).to be(false)
        end
      end
    end

    context 'when one of the scores status is :not_found' do
      before do
        analysis_item.status = :not_found
        analysis_item.save!
      end

      it 'expects score_report status :not_found' do
        subject.call

        expect(analysis_report.status).to eq('not_found')
      end
    end

    context 'when there is a payload' do
      let(:analysis_report) do
        create(
          :analysis_report,
          status: :wip, payload: 'http://alpop.com.br/fake-url'
        )
      end

      context 'when the API returns ok' do
        before do
          WebMock.disable_net_connect!

          stub_request(:post, analysis_report.payload).with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Faraday v2.12.2'
            }
          ).to_return(status: 200, body: '{}', headers: {})

          analysis_report.items.each do |analysis_item|
            analysis_item.status = :done

            create :analysis_prediction, item: analysis_item

            analysis_item.save!
          end

          allow(PayloadSender).to receive(:send).and_call_original
        end

        it 'expects the PayloadSender is called once' do
          subject.call

          expect(PayloadSender).to have_received(:send).once
          expect(analysis_report.status).to eq('done')
        end
      end

      context 'when the API returns timeout' do
        before do
          WebMock.disable_net_connect!

          @stub_request = stub_request(:post, analysis_report.payload).with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Faraday v2.12.2'
            }
          ).to_timeout

          analysis_report.items.each do |analysis_item|
            analysis_item.status = :done

            create :analysis_prediction, item: analysis_item

            analysis_item.save!
          end
        end

        it 'raises Timeout::Error and change analysis report status' do
          allow(PayloadSender).to receive(:send).and_raise(Timeout::Error)

          expect { subject.call }.to raise_error(Timeout::Error)
          expect(analysis_report.reload.status).to eq('done')
        end
      end

      context 'when the API returns error' do
        before do
          WebMock.disable_net_connect!

          stub_request(:post, analysis_report.payload).with(
            headers: {
              'Accept' => '*/*',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Faraday v2.12.2'
            }
          ).to_return(status: 404, body: '{}', headers: {})

          analysis_report.items.each do |analysis_item|
            analysis_item.status = :done

            create :analysis_prediction, item: analysis_item

            analysis_item.save!
          end
        end

        it 'raises a PayloadSender::ResponseError' do
          expect { subject.call }.to raise_error(Faraday::ResourceNotFound)
        end
      end
    end
  end
end
