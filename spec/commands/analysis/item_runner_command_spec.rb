# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Analysis::ItemRunnerCommand, type: :command do
  describe '#call' do
    subject(:item_command) { described_class.new(analysis_item) }

    let(:enabled_steps) { Analysis::Step.enabled }
    let(:reproved_hash) { { status: 'success', approved: false } }
    let(:approved_hash) do
      {
        status: 'success',
        approved: true,
        disapproval_situation: nil
      }
    end
    let(:failure_hash) do
      {
        status: 'failure',
        approved: false,
        disapproval_situation: nil
      }
    end
    let(:not_found_hash) do
      {
        status: 'not_found',
        approved: false,
        disapproval_situation: nil
      }
    end

    context 'when analysis item status is :todo or :wip' do
      let(:analysis_item) do
        create(
          :analysis_item,
          status: %i[wip todo].sample,
          disapproval_situation: nil
        )
      end

      it 'updates the analysis item status to :wip' do
        item_command.call

        expect(analysis_item.reload.status).to eq('wip')
      end
    end

    context 'when analysis item status is :done or :not_found' do
      let(:analysis_item) do
        create(
          :analysis_item,
          status: %i[done not_found].sample,
          disapproval_situation: nil
        )
      end

      it 'does not update the analysis item status' do
        item_command.call

        expect(analysis_item.reload.status).to eq(analysis_item.status)
      end
    end

    context 'when analysis item has error_status as boa_vista' do
      let(:analysis_item) do
        create(
          :analysis_item,
          status: :todo,
          error_status: 'boa_vista'
        )
      end

      it 'does not proceed with analyze_cpf' do
        expect_any_instance_of(described_class).not_to receive(:analyze_cpf) # rubocop:disable RSpec/AnyInstance

        item_command.call
      end
    end

    context 'when analysis item does not have error_status as boa_vista' do
      let(:analysis_item) do
        create(
          :analysis_item,
          status: :todo,
          error_status: :none
        )
      end

      it 'proceeds with analyze_cpf' do
        expect_any_instance_of(described_class).to receive(:analyze_cpf) # rubocop:disable RSpec/AnyInstance

        item_command.call
      end
    end

    context 'when analyzing CPF' do
      let(:analysis_item) do
        create :analysis_item, status: :todo, error_status: :none
      end
      let(:current_analysis) { analysis_item.clone_of || analysis_item }
      let(:steps) { create_list :analysis_step, 3 }

      before do
        allow(Analysis::Step).to receive_message_chain(:enabled, :order) # rubocop:disable RSpec/MessageChain
          .and_return(steps)
        allow_any_instance_of(described_class) # rubocop:disable RSpec/AnyInstance
          .to receive(:analysis_modules_runner)
      end

      it 'adds steps to the analysis item' do
        item_command.call

        expect(analysis_item.steps).to match_array(steps)
      end

      it 'calls analysis_modules_runner for each step' do
        steps.each do |step|
          expect_any_instance_of(item_command) # rubocop:disable RSpec/AnyInstance
            .to receive(:analysis_modules_runner)
            .with(step.command_class, current_analysis, analysis_item)
        end

        item_command.call
      end

      it 'breaks the loop if analysis item status is not wip' do
        allow(analysis_item).to receive(:status).and_return('done')

        item_command.call

        expect(analysis_item.reload.status).to eq('done')
      end
    end

    context 'when boa vista cadastral is successful' do
      let(:analysis_item) do
        create(
          :analysis_item,
          status: %i[wip todo].sample,
          disapproval_situation: nil
        )
      end
      let(:boa_vista_cadastral) { create :boa_vista_cadastral }
      let(:integrator_instance_double) do
        instance_double(BoaVista::CadastralIntegrator)
      end

      before do
        allow(BoaVista::CadastralIntegrator).to receive(:new)
          .and_return(integrator_instance_double)
        allow(integrator_instance_double).to receive(:create_resource)
          .and_return(boa_vista_cadastral)
      end

      describe '#process_cpf' do
        let(:multi_softmax_prediction) do
          create :analysis_prediction, label: 'multi_softmax'
        end
        let(:pre_prediction_reproved_hash) do
          reproved_hash.merge(disapproval_situation:)
        end
        let(:disapproval_situation) do
          %i[
            reproved_by_obit_indication reproved_by_relative
            reproved_by_trial reproved_by_age_and_income
            blocked_negativity exceeded_debits
            reproved_by_recent_debit reproved_by_protested_title
          ].sample
        end
        let(:analysis_item_prediction) { analysis_item.predictions.last }

        before do
          enabled_steps.each do |step|
            allow(Object.const_get(step.command_class))
              .to receive(:call).and_return(approved_hash)
          end
        end

        context 'when it has a clone, runs previous analysis item in steps' do
          let(:previous_analysis_item) { create :analysis_item, :done }
          let(:analysis_item) do
            create :analysis_item, :wip, clone_of: previous_analysis_item
          end

          context 'when reproved by ProScore::BouncedCheckCommand' do
            let(:bounced_check_command) { ProScore::BouncedCheckCommand }

            let(:blocked_cpf_hash) do
              reproved_hash.merge(
                disapproval_situation: :reproved_by_bounced_check
              )
            end

            before do
              allow(bounced_check_command).to receive(:call)
                .with(previous_analysis_item).and_return(blocked_cpf_hash)
            end

            it 'changes cloned disapproval_situation' do
              expect { item_command.call }
                .to change(analysis_item, :disapproval_situation)
                .to('reproved_by_bounced_check')
                .and change(analysis_item, :status).to('done')
            end

            it 'does not change any original score atributes' do
              expect { item_command.call }
                .not_to change(previous_analysis_item, :attributes)
            end
          end

          context 'when reproved by PrePredictionCommand' do
            let(:pre_prediction_command) { PrePredictionCommand }

            before do
              allow(pre_prediction_command).to receive(:call)
                .with(previous_analysis_item)
                .and_return(pre_prediction_reproved_hash)
            end

            it 'updates the cloned score correctly' do
              expect { item_command.call }
                .to change(analysis_item, :disapproval_situation)
                .to(disapproval_situation.to_s)
                .and change(analysis_item, :status).to('done')
            end

            it 'creates a prediction for the cloned score' do
              expect { item_command.call }
                .to change(analysis_item.predictions, :count).by(1)

              expect(analysis_item_prediction.label).to eq('pre_prediction')
            end

            it 'does not change any original score atributes' do
              expect { item_command.call }
                .not_to change(previous_analysis_item, :attributes)
            end
          end

          context 'when the previous analysis item pass by all steps' do
            let(:prediction_command) { Analysis::PredictionCommand }

            before do
              allow(prediction_command).to receive(:call)
                .and_return(multi_softmax_prediction)
            end

            it 'calls PredictionCommand using original score' do
              expect(prediction_command).to receive(:call)
                .with(previous_analysis_item)

              item_command.call
            end

            it 'creates a multi_softmax prediction for the cloned score' do
              item_command.call

              expect(analysis_item_prediction.label).to eq('multi_softmax')
            end

            it 'updates cloned score status to done' do
              expect { item_command.call }
                .to change(analysis_item, :status).to('done')
            end

            it 'calls Analysis::ReportSyncCommand' do
              expect(Analysis::ReportSyncCommand)
                .to receive(:call).with(analysis_item.report)

              item_command.call
            end

            it 'does not change any original score atributes' do
              expect { item_command.call }
                .not_to change(previous_analysis_item, :attributes)
            end

            it 'does not change any original score predictions' do
              expect { item_command.call }
                .not_to change { previous_analysis_item.predictions.count }
            end
          end
        end

        context 'when stops and is reproved by ProScore::BouncedCheckCommand' do
          let(:bounced_check_command) { ProScore::BouncedCheckCommand }
          let(:blocked_cpf_hash) do
            reproved_hash.merge(
              disapproval_situation: :reproved_by_bounced_check
            )
          end

          before do
            allow(bounced_check_command).to receive(:call)
              .and_return(blocked_cpf_hash)
          end

          it 'changes disapproval_situation to reproved_by_bounced_check' do
            expect { item_command.call }
              .to change(analysis_item, :disapproval_situation)
              .to('reproved_by_bounced_check')
              .and change(analysis_item, :status).to('done')
          end
        end

        context 'when ProScore::BouncedCheckCommand fails' do
          let(:bounced_check_command) { ProScore::BouncedCheckCommand }

          before do
            allow(bounced_check_command).to receive(:call)
              .and_return(failure_hash)
          end

          it 'changes status to error' do
            expect { item_command.call }
              .to change(analysis_item, :status).to('error')
          end
        end

        context 'when BigDataCorpCommand fails' do
          let(:big_data_corp_command) { Provenir::BigDataCorpCommand }

          before do
            allow(bounced_check_command).to receive(:call)
              .and_return(failure_hash)
          end

          it 'changes status to error' do
            expect { item_command.call }
              .to change(analysis_item, :status).to('error')
          end
        end

        context 'when AcertaEssencialCommand fails' do
          let(:acerta_essencial_command) { BoaVista::AcertaEssencialCommand }

          before do
            allow(acerta_essencial_command).to receive(:call)
              .and_return(failure_hash)
          end

          it 'changes status to error' do
            expect do
              item_command.call
            end.to change(analysis_item, :status).to('error')
          end
        end

        context 'when AcertaEssencialCommand is not found' do
          let(:acerta_essencial_command) { BoaVista::AcertaEssencialCommand }

          before do
            allow(acerta_essencial_command).to receive(:call)
              .and_return(not_found_hash)
          end

          it 'changes status to not_found' do
            expect { item_command.call }
              .to change(analysis_item, :status).to('not_found')
          end
        end

        context 'when reproved by PrePredictionCommand' do
          let(:pre_prediction_command) { PrePredictionCommand }

          before do
            allow(pre_prediction_command).to receive(:call)
              .and_return(pre_prediction_reproved_hash)
          end

          it 'updates the score correctly' do
            expect { item_command.call }
              .to change(analysis_item, :disapproval_situation)
              .to(disapproval_situation.to_s)
              .and change(analysis_item, :status).to('done')
          end

          it 'creates a prediction for the score' do
            expect { item_command.call }
              .to change(analysis_item.predictions, :count).by(1)

            expect(analysis_item_prediction.label).to eq('pre_prediction')
          end
        end

        context 'when the score pass by all steps' do
          let(:prediction_command) { Analysis::PredictionCommand }

          before do
            allow(prediction_command)
              .to receive(:call).and_return(multi_softmax_prediction)
          end

          it 'calls PredictionCommand' do
            expect(prediction_command).to receive(:call).with(analysis_item)

            item_command.call
          end

          it 'creates a multi_softmax prediction for the score' do
            item_command.call

            expect(analysis_item_prediction.label).to eq('multi_softmax')
          end

          it 'updates score status to done' do
            expect { item_command.call }
              .to change(analysis_item, :status).to('done')
          end

          it 'calls ScoreReportSyncCommand' do
            expect(Analysis::ReportSyncCommand)
              .to receive(:call).with(analysis_item.report)

            item_command.call
          end
        end
      end
    end
  end
end
