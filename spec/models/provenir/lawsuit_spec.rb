# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_lawsuits
#
#  id                                  :bigint           not null, primary key
#  lawsuit_number                      :string
#  lawsuit_type                        :string
#  main_subject                        :text
#  court_name                          :string
#  court_level                         :string
#  court_type                          :string
#  court_district                      :string
#  judging_body                        :string
#  state                               :string
#  status                              :string
#  lawsuit_host_service                :string
#  inferred_cnj_subject_name           :string
#  inferred_cnj_subject_number         :string
#  inferred_cnj_procedure_type_name    :string
#  inferred_broad_cnj_subject_name     :string
#  inferred_broad_cnj_subject_number   :string
#  number_of_volumes                   :integer
#  number_of_pages                     :integer
#  value                               :string
#  res_judicata_date                   :datetime
#  close_date                          :datetime
#  redistribution_date                 :datetime
#  publication_date                    :datetime
#  notice_date                         :datetime
#  last_movement_date                  :datetime
#  capture_date                        :datetime
#  last_update                         :datetime
#  number_of_parties                   :integer
#  number_of_updates                   :integer
#  law_suit_age                        :integer
#  average_number_of_updates_per_month :float
#  reason_for_concealed_data           :string
#  provenir_process_id                 :bigint           not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#
require 'spec_helper'

RSpec.describe Provenir::Lawsuit, type: :model do
  describe 'factories' do
    subject { build :provenir_lawsuit }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:process)
        .class_name('Provenir::Process')
        .with_foreign_key('provenir_process_id')
        .inverse_of(:lawsuits)
    end

    it do
      expect(subject).to have_many(:decisions)
        .class_name('Provenir::Decision')
        .with_foreign_key('provenir_lawsuit_id')
        .inverse_of(:lawsuit)
        .dependent(:destroy)
    end

    it do
      expect(subject).to have_many(:parties)
        .class_name('Provenir::Party')
        .with_foreign_key('provenir_lawsuit_id')
        .inverse_of(:lawsuit)
        .dependent(:destroy)
    end

    it do
      expect(subject).to have_many(:petitions)
        .class_name('Provenir::Petition')
        .with_foreign_key('provenir_lawsuit_id')
        .inverse_of(:lawsuit)
        .dependent(:destroy)
    end

    it do
      expect(subject).to have_many(:updates)
        .class_name('Provenir::Update')
        .with_foreign_key('provenir_lawsuit_id')
        .inverse_of(:lawsuit)
        .dependent(:destroy)
    end
  end

  describe 'nested_attributes' do
    it { is_expected.to accept_nested_attributes_for(:decisions) }
    it { is_expected.to accept_nested_attributes_for(:parties) }
    it { is_expected.to accept_nested_attributes_for(:updates) }
  end

  describe 'custom methods included by concern' do
    before { create :lawsuit_banned_keyword }

    describe '#disapproved?' do
      subject { lawsuit.disapproved? }

      let(:big_data_corp) { create :provenir_big_data_corp }
      let(:basic_datum) do
        create :provenir_basic_datum, big_data_corp:
      end
      let(:process) { create :provenir_process, big_data_corp: }
      let(:lawsuit) { create :provenir_lawsuit, process: }

      before do
        create_list :provenir_party, 3, :neutral, lawsuit: lawsuit
        create_list :provenir_party, 3, :active, lawsuit: lawsuit
        create_list :provenir_party, 3, :passive, lawsuit: lawsuit
      end

      context 'when searched name is defendant and banned keywords present' do
        context 'when searched name is found by cpf' do
          let!(:lawsuit) do
            create :provenir_lawsuit, main_subject: 'crime', process:
          end
          let!(:searched_party) do
            create(
              :provenir_party,
              :passive,
              party_doc: basic_datum.tax_id_number,
              lawsuit: lawsuit
            )
          end

          it { is_expected.to be true }
        end

        context 'when searched name is polarity: passive only' do
          let!(:lawsuit) do
            create :provenir_lawsuit, main_subject: 'crime', process:
          end
          let!(:searched_party) do
            create(
              :provenir_party,
              :passive,
              name: basic_datum.name,
              lawsuit: lawsuit
            )
          end

          it { is_expected.to be true }
        end

        context 'when searched name is both polarity passive and active' do
          let!(:lawsuit) do
            create :provenir_lawsuit, main_subject: 'crime', process:
          end
          let!(:searched_party_passive) do
            create(
              :provenir_party,
              :passive,
              name: basic_datum.name,
              lawsuit: lawsuit
            )
          end
          let!(:searched_party_active) do
            create(
              :provenir_party,
              :active,
              name: basic_datum.name,
              lawsuit: lawsuit
            )
          end

          it { is_expected.to be true }
        end

        context 'when searched name is both polarity passive and neutral' do
          let!(:lawsuit) do
            create :provenir_lawsuit, main_subject: 'crime', process:
          end
          let!(:searched_party_passive) do
            create(
              :provenir_party,
              :passive,
              name: basic_datum.name,
              lawsuit: lawsuit
            )
          end
          let!(:searched_party_neutral) do
            create(
              :provenir_party,
              :neutral,
              name: basic_datum.name,
              lawsuit:
            )
          end

          it { is_expected.to be true }
        end
      end

      context 'when neither defendant nor banned keywords are present' do
        context 'when searched name is polarity: active' do
          let!(:lawsuit) { create :provenir_lawsuit, process: }
          let!(:searched_party) do
            create(
              :provenir_party,
              :active,
              name: basic_datum.name,
              lawsuit:
            )
          end

          it { is_expected.to be false }
        end

        context 'when searched name is polarity: neutral' do
          let!(:lawsuit) { create :provenir_lawsuit, process: }
          let!(:searched_party) do
            create(
              :provenir_party,
              :neutral,
              name: basic_datum.name,
              lawsuit: lawsuit
            )
          end

          it { is_expected.to be false }
        end

        context 'when searched name is both polarity active and neutral' do
          let!(:lawsuit) { create :provenir_lawsuit, process: }
          let!(:searched_party_active) do
            create(
              :provenir_party,
              :active,
              name: basic_datum.name,
              lawsuit: lawsuit
            )
          end
          let!(:searched_party_neutral) do
            create(
              :provenir_party,
              :neutral,
              name: basic_datum.name,
              lawsuit: lawsuit
            )
          end

          it { is_expected.to be false }
        end
      end

      context 'when cpf is defendant but no keywords are present' do
        let!(:lawsuit) { create :provenir_lawsuit, process: }
        let!(:searched_party) do
          create(
            :provenir_party,
            :passive,
            party_doc: basic_datum.tax_id_number,
            lawsuit: lawsuit
          )
        end

        it { is_expected.to be false }
      end

      context 'when searched name is defendant but no keywords are present' do
        let(:lawsuit) { create :provenir_lawsuit, process: }
        let!(:searched_party) do
          create(
            :provenir_party, :passive, name: basic_datum.name, lawsuit:
          )
        end

        it { is_expected.to be false }
      end

      context 'when searched name is not defendant but keywords are present' do
        context 'when searched name is polarity: active' do
          let(:lawsuit) do
            create :provenir_lawsuit, main_subject: 'crime', process:
          end
          let!(:searched_party) do
            create(
              :provenir_party,
              :active,
              name: basic_datum.name,
              lawsuit: lawsuit
            )
          end

          it { is_expected.to be false }
        end

        context 'when searched name is polarity: neutral' do
          let(:lawsuit) do
            create :provenir_lawsuit, main_subject: 'crime', process:
          end
          let!(:searched_party) do
            create(
              :provenir_party,
              :neutral,
              name: basic_datum.name,
              lawsuit: lawsuit
            )
          end

          it { is_expected.to be false }
        end

        context 'when searched name is both polarity active and neutral' do
          let(:lawsuit) do
            create :provenir_lawsuit, main_subject: 'crime', process:
          end
          let!(:searched_party_active) do
            create(
              :provenir_party,
              :active,
              name: basic_datum.name,
              lawsuit: lawsuit
            )
          end
          let!(:searched_party_neutral) do
            create(
              :provenir_party,
              :neutral,
              name: basic_datum.name,
              lawsuit: lawsuit
            )
          end

          it { is_expected.to be false }
        end
      end
    end

    describe '#defendant?' do
      subject { lawsuit.defendant? }

      let(:big_data_corp) { create :provenir_big_data_corp }
      let!(:basic_datum) do
        create :provenir_basic_datum, big_data_corp:
      end
      let(:process) { create :provenir_process, big_data_corp: }
      let(:lawsuit) { create :provenir_lawsuit, process: }

      before do
        create_list :provenir_party, 2, :passive, lawsuit: lawsuit
        create_list :provenir_party, 2, :active, lawsuit: lawsuit
        create_list :provenir_party, 2, :neutral, lawsuit: lawsuit
      end

      context 'when defendant name is closer to lawsuit party name' do
        let!(:searched_party) do
          create(
            :provenir_party, :passive, name: basic_datum.name, lawsuit:
          )
        end

        it { is_expected.to be true }
      end

      context 'when plaintiff name is closer to lawsuit party name' do
        let!(:searched_party) do
          create(
            :provenir_party, :active, name: basic_datum.name, lawsuit:
          )
        end

        it { is_expected.to be false }
      end

      context 'when neutral name is closer to lawsuit party name' do
        let!(:searched_party) do
          create(
            :provenir_party, :neutral, name: basic_datum.name, lawsuit:
          )
        end

        it { is_expected.to be false }
      end

      context 'when defendant cpf is present in lawsuit parties' do
        let!(:searched_party) do
          create(
            :provenir_party,
            :passive,
            party_doc: basic_datum.tax_id_number,
            lawsuit:
          )
        end

        it { is_expected.to be true }
      end
    end

    describe '#banned_keywords_present?' do
      subject { lawsuit.banned_keywords_present? }

      let(:big_data_corp) { create :provenir_big_data_corp }
      let(:basic_datum) do
        create :provenir_basic_datum, big_data_corp:
      end
      let(:process) { create :provenir_process, big_data_corp: }
      let!(:searched_party) do
        create(
          :provenir_party, :passive, name: basic_datum.name, lawsuit: lawsuit
        )
      end

      context 'when banned keywords are present' do
        let(:lawsuit) do
          create :provenir_lawsuit, main_subject: 'crime', process: process
        end

        it { is_expected.to be true }
      end

      context 'when banned keywords are present within a phrase' do
        let(:lawsuit) do
          create(
            :provenir_lawsuit,
            main_subject: 'crime correlato',
            process: process
          )
        end

        it { is_expected.to be true }
      end

      context 'when a column of subject_matters is blank' do
        let(:lawsuit) do
          create(
            :provenir_lawsuit,
            main_subject: nil,
            lawsuit_type: nil,
            process: process
          )
        end

        it { is_expected.to be false }
      end

      context 'when banned keywords are not present' do
        let(:lawsuit) { create :provenir_lawsuit, process: process }

        it { is_expected.to be false }
      end
    end

    describe '#exceptionable?' do
      context 'when lawsuit is exceptionable' do
        context 'when inactive, value is below 1000 and exceptionable word' do
          subject { lawsuit.exceptionable? }

          let(:big_data_corp) { create :provenir_big_data_corp }
          let(:basic_datum) do
            create :provenir_basic_datum, big_data_corp: big_data_corp
          end
          let(:process) do
            create :provenir_process, big_data_corp: big_data_corp
          end
          let(:lawsuit) do
            create(
              :provenir_lawsuit,
              main_subject: 'EXECUÇÃO DE TÍTULO',
              status: 'ARQUIVADO',
              value: 999.90,
              process: process
            )
          end
          let!(:searched_party) do
            create(
              :provenir_party,
              :passive,
              name: basic_datum.name,
              lawsuit: lawsuit
            )
          end

          before { create :lawsuit_banned_keyword, :execution }

          it { is_expected.to be true }
        end
      end

      context 'when lawsuit is not exceptionable' do
        context 'when there is non-exceptionable keywords' do
          subject { lawsuit.exceptionable? }

          let(:big_data_corp) { create :provenir_big_data_corp }
          let(:basic_datum) do
            create :provenir_basic_datum, big_data_corp:
          end
          let(:process) do
            create :provenir_process, big_data_corp:
          end
          let!(:lawsuit) do
            create(
              :provenir_lawsuit,
              main_subject: 'crime',
              status: 'ARQUIVADO',
              process:
            )
          end
          let!(:searched_party) do
            create(
              :provenir_party,
              :passive,
              name: basic_datum.name,
              lawsuit:
            )
          end

          it { is_expected.to be false }
        end

        context 'when both exceptionable and non-exceptionable keywords' do
          subject { lawsuit.exceptionable? }

          let(:big_data_corp) { create :provenir_big_data_corp }
          let(:basic_datum) do
            create :provenir_basic_datum, big_data_corp:
          end
          let(:process) do
            create :provenir_process, big_data_corp:
          end
          let!(:lawsuit) do
            create(
              :provenir_lawsuit,
              main_subject: 'crime',
              lawsuit_type: 'EXECUÇÃO',
              status: 'ARQUIVADO',
              process:
            )
          end
          let!(:searched_party) do
            create(
              :provenir_party,
              :passive,
              name: basic_datum.name,
              lawsuit:
            )
          end

          before do
            create :lawsuit_banned_keyword, :criminal
            create :lawsuit_banned_keyword, :execution
          end

          it { is_expected.to be false }
        end

        context 'when status is active' do
          subject { lawsuit.exceptionable? }

          let(:big_data_corp) { create :provenir_big_data_corp }
          let(:basic_datum) do
            create :provenir_basic_datum, big_data_corp:
          end
          let(:process) do
            create :provenir_process, big_data_corp:
          end
          let(:lawsuit) do
            create(
              :provenir_lawsuit,
              main_subject: 'EXECUÇÃO DE TÍTULO',
              status: 'ATIVO',
              value: 999.90,
              process:
            )
          end
          let!(:searched_party) do
            create(
              :provenir_party,
              :passive,
              name: basic_datum.name,
              lawsuit:
            )
          end

          before { create :lawsuit_banned_keyword, :execution }

          it { is_expected.to be false }
        end

        context 'when status is undefined' do
          subject { lawsuit.exceptionable? }

          let(:big_data_corp) { create :provenir_big_data_corp }
          let(:basic_datum) do
            create :provenir_basic_datum, big_data_corp:
          end
          let(:process) do
            create :provenir_process, big_data_corp:
          end
          let(:lawsuit) do
            create(
              :provenir_lawsuit,
              main_subject: 'EXECUÇÃO DE TÍTULO',
              status: 'INDEFINIDO',
              value: 999.90,
              process:
            )
          end
          let!(:searched_party) do
            create(
              :provenir_party,
              :passive,
              name: basic_datum.name,
              lawsuit:
            )
          end

          before { create :lawsuit_banned_keyword, :execution }

          it { is_expected.to be false }
        end

        context 'when is inactive, word exceptionable, but value is > 1000' do
          subject { lawsuit.exceptionable? }

          let(:big_data_corp) { create :provenir_big_data_corp }
          let(:basic_datum) do
            create :provenir_basic_datum, big_data_corp:
          end
          let(:process) do
            create :provenir_process, big_data_corp:
          end
          let(:lawsuit) do
            create(
              :provenir_lawsuit,
              main_subject: 'EXECUÇÃO DE TÍTULO',
              status: 'ARQUIVADO',
              value: 1001.00,
              process:
            )
          end
          let!(:searched_party) do
            create(
              :provenir_party,
              :passive,
              name: basic_datum.name,
              lawsuit:
            )
          end

          before { create :lawsuit_banned_keyword, :execution }

          it { is_expected.to be false }
        end

        context 'when inactive and value < 1000 without exceptionable word' do
          subject { lawsuit.exceptionable? }

          let(:big_data_corp) { create :provenir_big_data_corp }
          let(:basic_datum) do
            create :provenir_basic_datum, big_data_corp:
          end
          let(:process) do
            create :provenir_process, big_data_corp:
          end
          let(:lawsuit) do
            create(
              :provenir_lawsuit,
              main_subject: 'foobar',
              status: 'ARQUIVADO',
              value: 999.90,
              process:
            )
          end
          let!(:searched_party) do
            create(
              :provenir_party,
              :passive,
              name: basic_datum.name,
              lawsuit:
            )
          end

          before { create :lawsuit_banned_keyword, :execution }

          it { is_expected.to be false }
        end
      end
    end
  end
end
