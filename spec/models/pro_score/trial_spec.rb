# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trials
#
#  id                       :bigint           not null, primary key
#  numero_plugin            :string
#  numero_do_processo_unico :string
#  data_distribuicao        :datetime
#  area                     :string
#  causa_moeda              :string
#  causa_valor              :string
#  unidade_origem           :string
#  url_processo             :string
#  sistema                  :string
#  data_processamento       :datetime
#  tribunal                 :string
#  uf                       :string
#  segmento                 :string
#  classe_processual_nome   :string
#  orgao_julgador           :string
#  juiz                     :string
#  pro_score_report_id      :bigint           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
require 'spec_helper'

RSpec.describe ProScore::Trial, type: :model do
  describe 'factories' do
    context 'without disapproved words' do
      subject { build :pro_score_trial }

      it { is_expected.to be_valid }
    end

    context 'with disapproved words in area' do
      subject { build :pro_score_trial, :with_disapproved_area }

      it { is_expected.to be_valid }
    end

    context 'with disapproved words in classe processual' do
      subject do
        build :pro_score_trial, :with_disapproved_classe_processual_nome
      end

      it { is_expected.to be_valid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:report) }
    it { is_expected.to have_many(:parts) }
    it { is_expected.to have_many(:lawyers) }
    it { is_expected.to have_many(:topics) }
    it { is_expected.to have_many(:motions) }
  end

  describe 'custom methods' do
    describe '#defendant_and_disapproved?' do
      subject { create :pro_score_trial, report: pro_score_report }

      let(:analysis_item) { create :analysis_item, :done }
      let!(:pro_score_report) { create(:pro_score_report, analysis_item:) }

      context 'when is defendant' do
        before do
          create(
            :pro_score_trial_part,
            :defendant,
            trial: subject,
            nome: analysis_item.name
          )
          create(
            :pro_score_trial_part,
            :plaintiff,
            trial: subject,
            nome: 'foo bar'
          )
        end

        context 'when trial is disapproved' do
          context 'when it is disapproved by area' do
            subject do
              create(
                :pro_score_trial,
                :with_disapproved_area,
                report: pro_score_report
              )
            end

            it 'returns true' do
              expect(subject).to be_defendant_and_disapproved
            end

            context 'when it is a joinder with codefendant and coplaintiff' do
              before do
                create :pro_score_trial_part, :defendant, trial: subject
                create :pro_score_trial_part, :plaintiff, trial: subject
              end

              it 'returns true' do
                expect(subject).to be_defendant_and_disapproved
              end
            end
          end

          context 'when it is disapproved by classe_processual_nome' do
            subject do
              create(
                :pro_score_trial,
                :with_disapproved_classe_processual_nome,
                report: pro_score_report
              )
            end

            it 'returns true' do
              expect(subject).to be_defendant_and_disapproved
            end

            context 'when it is a joinder with codefendant and coplaintiff' do
              before do
                create :pro_score_trial_part, :defendant, trial: subject
                create :pro_score_trial_part, :plaintiff, trial: subject
              end

              it 'returns true' do
                expect(subject).to be_defendant_and_disapproved
              end
            end
          end

          context "when it is disapproved by at least one topic's title" do
            subject do
              create(
                :pro_score_trial,
                report: pro_score_report,
                area: 'FOO',
                classe_processual_nome: 'BAR'
              )
            end

            before do
              create(
                :pro_score_trial_topic,
                :with_disapproved_title,
                trial: subject
              )
            end

            it 'returns true' do
              expect(subject).to be_defendant_and_disapproved
            end

            context 'when it is a joinder with codefendant and coplaintiff' do
              before do
                create :pro_score_trial_part, :defendant, trial: subject
                create :pro_score_trial_part, :plaintiff, trial: subject
              end

              it 'returns true' do
                expect(subject).to be_defendant_and_disapproved
              end
            end
          end
        end

        context 'when trial is approved' do
          subject do
            create(
              :pro_score_trial,
              report: pro_score_report,
              area: 'FOO',
              classe_processual_nome: 'BAR'
            )
          end

          before do
            create :pro_score_trial_topic, trial: subject
          end

          it 'returns falsey' do
            expect(subject).not_to be_defendant_and_disapproved
          end

          context 'when it is a joinder with coplaintiff and codefendant' do
            before do
              create :pro_score_trial_part, :defendant, trial: subject
              create :pro_score_trial_part, :plaintiff, trial: subject
            end

            it 'returns false' do
              expect(subject).not_to be_defendant_and_disapproved
            end
          end
        end
      end

      context 'when it is coplaintiff' do
        before do
          create(
            :pro_score_trial_part,
            :defendant,
            trial: subject,
            nome: 'foo'
          )
          create(
            :pro_score_trial_part,
            :plaintiff,
            trial: subject,
            nome: analysis_item.name
          )
        end

        it 'returns false' do
          expect(subject).not_to be_defendant_and_disapproved
        end

        context 'when it is a joinder with codefendant and coplaintiff' do
          before do
            create :pro_score_trial_part, :defendant, trial: subject
            create :pro_score_trial_part, :plaintiff, trial: subject
          end

          it 'returns false' do
            expect(subject).not_to be_defendant_and_disapproved
          end
        end
      end
    end

    describe '#defendant?' do
      subject { create :pro_score_trial, report: pro_score_report }

      let(:analysis_item) { create :analysis_item, :done }
      let!(:pro_score_report) { create(:pro_score_report, analysis_item:) }

      context 'when is defendant' do
        before do
          create(
            :pro_score_trial_part,
            :defendant,
            trial: subject,
            nome: analysis_item.name
          )
          create(
            :pro_score_trial_part,
            :plaintiff,
            trial: subject,
            nome: 'foo bar'
          )
        end

        it 'returns true' do
          expect(subject).to be_defendant
        end
      end

      context 'when it is coplaintiff' do
        before do
          create(
            :pro_score_trial_part,
            :defendant,
            trial: subject,
            nome: 'foo'
          )
          create(
            :pro_score_trial_part,
            :plaintiff,
            trial: subject,
            nome: analysis_item.name
          )
        end

        it 'returns false' do
          expect(subject).not_to be_defendant
        end
      end
    end
  end
end
