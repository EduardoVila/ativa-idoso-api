# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_acerta_essencials
#
#  id            :bigint           not null, primary key
#  consumer_type :string           not null
#  cpf           :string           not null
#  credit_type   :integer          default("CC"), not null
#  raw_data      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  consumer_id   :uuid             not null
#
# Indexes
#
#  index_boa_vista_acerta_essencials_on_consumer  (consumer_type,consumer_id) UNIQUE
#
require 'spec_helper'

RSpec.describe BoaVista::AcertaEssencial, type: :model do
  describe 'factories' do
    subject { build :boa_vista_acerta_essencial }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    subject { create :boa_vista_acerta_essencial }

    it { is_expected.to validate_presence_of :cpf }
    it { is_expected.to validate_presence_of :credit_type }

    it {
      expect(subject).to validate_uniqueness_of(:consumer_id)
        .scoped_to(:consumer_type)
        .ignoring_case_sensitivity
    }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:consumer) }
    it { is_expected.to have_many(:additional_informations) }
    it { is_expected.to have_many(:debits) }
    it { is_expected.to have_many(:previous_queries) }
    it { is_expected.to have_many(:protested_titles) }
    it { is_expected.to have_one(:protested_title_summary) }
    it { is_expected.to have_one(:identification) }
    it { is_expected.to have_one(:debit_occurrence) }
    it { is_expected.to have_one(:current_account_historic) }
    it { is_expected.to have_one(:location) }
    it { is_expected.to have_one(:cheque_additional_information) }
    it { is_expected.to have_one(:decision) }
    it { is_expected.to have_one(:zip_code_confirmation) }
    it { is_expected.to have_one(:documents_name) }
    it { is_expected.to have_many(:list_of_returns_reported_by_ccfs) }
    it { is_expected.to have_one(:returns_reported_by_user) }
    it { is_expected.to have_one(:cheques_stopped_for_reason21) }
    it { is_expected.to have_one(:historic_informed_cheque) }
    it { is_expected.to have_one(:previous_cheque_consultation) }
    it { is_expected.to have_one(:summary_of_returns_reported_by_user) }
    it { is_expected.to have_many(:score_rating_several_models) }
    it { is_expected.to have_one(:record_message) }
    it { is_expected.to have_one(:previous90_days_consultation) }
    it { is_expected.to have_one(:cheque_stopped) }
    it { is_expected.to have_one(:summary_devolution_reported_by_ccf) }
    it { is_expected.to have_one(:summary_previous_query_cheque) }
    it { is_expected.to have_one(:phone_confirmation) }
    it { is_expected.to have_one(:bank_branch_phones_address) }
  end

  describe '#debit_with_maximum_value' do
    before do
      subject { create :boa_vista_acerta_essencial }
    end

    context 'when there are debits' do
      subject { create :boa_vista_acerta_essencial }

      let!(:debit1) do
        create :boa_vista_debit,
               boa_vista_acerta_essencial: subject,
               value: '1000'
      end
      let!(:debit2) do
        create :boa_vista_debit,
               boa_vista_acerta_essencial: subject,
               value: '500'
      end

      it 'returns the higher debit value' do
        expect(subject.debit_with_maximum_value).to eq(debit1.value.to_f)
      end
    end

    context 'when there are not debits' do
      it 'returns nil value' do
        expect(subject.debit_with_maximum_value).to be_nil
      end
    end
  end

  describe '#debit_with_minimum_value' do
    before do
      subject { create :boa_vista_acerta_essencial }
    end

    context 'when there are debits' do
      subject { create :boa_vista_acerta_essencial }

      let!(:debit1) do
        create :boa_vista_debit,
               boa_vista_acerta_essencial: subject,
               value: '1000'
      end
      let!(:debit2) do
        create :boa_vista_debit,
               boa_vista_acerta_essencial: subject,
               value: '500'
      end

      it 'returns the higher debit value' do
        expect(subject.debit_with_minimum_value).to eq(debit2.value.to_f)
      end
    end

    context 'when there are not debits' do
      it 'returns nil value' do
        expect(subject.debit_with_minimum_value).to be_nil
      end
    end
  end

  describe '#debits_total_value' do
    before do
      subject { create :boa_vista_acerta_essencial }
    end

    context 'when there are debits' do
      subject { create :boa_vista_acerta_essencial }

      let!(:debit1) do
        create :boa_vista_debit,
               boa_vista_acerta_essencial: subject,
               value: '1000'
      end
      let!(:debit2) do
        create :boa_vista_debit,
               boa_vista_acerta_essencial: subject,
               value: '500'
      end
      let(:expected_value) { debit1.value.to_f + debit2.value.to_f }

      it 'returns the higher debit value' do
        expect(subject.debits_total_value).to eq(expected_value)
      end
    end

    context 'when there are not debits' do
      it 'returns nil value' do
        expect(subject.debits_total_value).to eq(0)
      end
    end
  end

  describe '#days_since_the_last_debit' do
    before do
      subject { create :boa_vista_acerta_essencial }
    end

    context 'when there are debits' do
      subject { create :boa_vista_acerta_essencial }

      let!(:debit1) do
        create :boa_vista_debit,
               boa_vista_acerta_essencial: subject,
               occurrence_date: '11/02/2021'
      end
      let!(:debit2) do
        create :boa_vista_debit,
               boa_vista_acerta_essencial: subject,
               occurrence_date: '11/03/2021'
      end
      let(:expected_value) do
        (Time.zone.today - Date.parse(debit2.occurrence_date)).to_i
      end

      it 'returns the higher debit value' do
        expect(subject.days_since_the_last_debit).to eq(expected_value)
      end
    end

    context 'when there are not debits' do
      it 'returns nil value' do
        expect(subject.days_since_the_last_debit).to be_nil
      end
    end
  end

  describe '#protested_title_with_maximum_value' do
    before do
      subject { create :boa_vista_acerta_essencial }
    end

    context 'when there are protested_titles' do
      subject { create :boa_vista_acerta_essencial }

      let!(:protested_title1) do
        create :boa_vista_protested_title,
               boa_vista_acerta_essencial: subject,
               value: '1000'
      end
      let!(:protested_title2) do
        create :boa_vista_protested_title,
               boa_vista_acerta_essencial: subject,
               value: '500'
      end

      it 'returns the higher protested_title value' do
        expect(subject.protested_title_with_maximum_value)
          .to eq(protested_title1.value.to_f)
      end
    end

    context 'when there are not protested_titles' do
      it 'returns nil value' do
        expect(subject.protested_title_with_maximum_value).to be_nil
      end
    end
  end

  describe '#protested_title_with_minimum_value' do
    before do
      subject { create :boa_vista_acerta_essencial }
    end

    context 'when there are protested_titles' do
      subject { create :boa_vista_acerta_essencial }

      let!(:protested_title1) do
        create :boa_vista_protested_title,
               boa_vista_acerta_essencial: subject,
               value: '1000'
      end
      let!(:protested_title2) do
        create :boa_vista_protested_title,
               boa_vista_acerta_essencial: subject,
               value: '500'
      end

      it 'returns the higher protested_title value' do
        expect(subject.protested_title_with_minimum_value)
          .to eq(protested_title2.value.to_f)
      end
    end

    context 'when there are not protested_titles' do
      it 'returns nil value' do
        expect(subject.protested_title_with_minimum_value).to be_nil
      end
    end
  end

  describe '#protested_titles_total_value' do
    before do
      subject { create :boa_vista_acerta_essencial }
    end

    context 'when there are protested_titles' do
      subject { create :boa_vista_acerta_essencial }

      let!(:protested_title1) do
        create :boa_vista_protested_title,
               boa_vista_acerta_essencial: subject,
               value: '1000'
      end
      let!(:protested_title2) do
        create :boa_vista_protested_title,
               boa_vista_acerta_essencial: subject,
               value: '500'
      end
      let(:expected_value) do
        protested_title1.value.to_f + protested_title2.value.to_f
      end

      it 'returns the higher protested_title value' do
        expect(subject.protested_titles_total_value).to eq(expected_value)
      end
    end

    context 'when there are not protested_titles' do
      it 'returns nil value' do
        expect(subject.protested_titles_total_value).to eq(0)
      end
    end
  end

  describe '#days_since_the_last_protested_title' do
    before do
      subject { create :boa_vista_acerta_essencial }
    end

    context 'when there are protested_titles' do
      subject { create :boa_vista_acerta_essencial }

      let!(:protested_title1) do
        create :boa_vista_protested_title,
               boa_vista_acerta_essencial: subject,
               occurrence_date: '11/02/2021'
      end
      let!(:protested_title2) do
        create :boa_vista_protested_title,
               boa_vista_acerta_essencial: subject,
               occurrence_date: '11/03/2021'
      end
      let(:expected_value) do
        (Time.zone.today - Date.parse(protested_title2.occurrence_date)).to_i
      end

      it 'returns the higher protested_title value' do
        expect(subject.days_since_the_last_protested_title)
          .to eq(expected_value)
      end
    end

    context 'when there are not protested_titles' do
      it 'returns nil value' do
        expect(subject.days_since_the_last_protested_title).to be_nil
      end
    end
  end

  describe '#presumed_income' do
    context 'when there are score_rating_several_models' do
      subject { create :boa_vista_acerta_essencial }

      let!(:score_rating_several_model) do
        create :boa_vista_score_rating_several_model,
               boa_vista_acerta_essencial: subject
      end

      it 'returns the presumed_income correctly' do
        expect(subject.presumed_income)
          .to eq(score_rating_several_model.text)
      end
    end

    context 'when there are not score_rating_several_models' do
      subject { create :boa_vista_acerta_essencial }

      it 'returns the value zero' do
        expect(subject.presumed_income).to eq('0')
      end
    end
  end

  describe '#division_between_income_and_debits_value' do
    context 'when there are presumed income and debits' do
      subject { create :boa_vista_acerta_essencial }

      let!(:score_rating_several_model) do
        create :boa_vista_score_rating_several_model,
               text: 'De R$ 801 a R$ 1.400',
               boa_vista_acerta_essencial: subject
      end

      let!(:debit) do
        create :boa_vista_debit,
               value: 100,
               boa_vista_acerta_essencial: subject
      end

      it 'returns the correctly value' do
        expect(
          subject.division_between_income_and_debits_value
        ).to eq(100.0 / 801)
      end
    end

    context 'when there are only the presumed income' do
      subject { create :boa_vista_acerta_essencial }

      let!(:score_rating_several_model) do
        create :boa_vista_score_rating_several_model,
               text: 'De R$ 801 a R$ 1.400',
               boa_vista_acerta_essencial: subject
      end

      it 'returns nil' do
        expect(subject.division_between_income_and_debits_value).to be_nil
      end
    end

    context 'when there are only the debit' do
      subject { create :boa_vista_acerta_essencial }

      let(:expected_value) { debit.value }
      let!(:debit) do
        create :boa_vista_debit,
               value: 100,
               boa_vista_acerta_essencial: subject
      end

      it 'returns nil' do
        expect(
          subject.division_between_income_and_debits_value
        ).to eq(expected_value.to_f)
      end
    end

    context 'when there are neither presumed income nor debits' do
      subject { create :boa_vista_acerta_essencial }

      it 'returns nil' do
        expect(subject.division_between_income_and_debits_value).to be_nil
      end
    end
  end

  describe '#division_between_income_and_protested_title_value' do
    context 'when there are presumed income and protested title' do
      subject { create :boa_vista_acerta_essencial }

      let!(:score_rating_several_model) do
        create :boa_vista_score_rating_several_model,
               text: 'De R$ 801 a R$ 1.400',
               boa_vista_acerta_essencial: subject
      end

      let!(:protested_title) do
        create :boa_vista_protested_title,
               value: 100,
               boa_vista_acerta_essencial: subject
      end

      it 'returns the correctly value' do
        expect(
          subject.division_between_income_and_protested_title_value
        ).to eq(100.0 / 801)
      end
    end

    context 'when there are only the presumed income' do
      subject { create :boa_vista_acerta_essencial }

      let!(:score_rating_several_model) do
        create :boa_vista_score_rating_several_model,
               text: 'De R$ 801 a R$ 1.400',
               boa_vista_acerta_essencial: subject
      end

      it 'returns nil' do
        expect(
          subject.division_between_income_and_protested_title_value
        ).to be_nil
      end
    end

    context 'when there are only the protested title' do
      subject { create :boa_vista_acerta_essencial }

      let(:expected_value) { debit.value }
      let!(:debit) do
        create :boa_vista_protested_title,
               value: 100,
               boa_vista_acerta_essencial: subject
      end

      it 'returns nil' do
        expect(
          subject.division_between_income_and_protested_title_value
        ).to eq(expected_value.to_f)
      end
    end

    context 'when there are neither presumed income nor protested title' do
      subject { create :boa_vista_acerta_essencial }

      it 'returns nil' do
        expect(
          subject.division_between_income_and_protested_title_value
        ).to be_nil
      end
    end
  end

  describe '#age' do
    context 'when there are identification' do
      subject { create :boa_vista_acerta_essencial }

      let!(:identification) do
        create :boa_vista_identification,
               birth_date: '11/02/1990',
               boa_vista_acerta_essencial: subject
      end

      it 'returns the correctly age' do
        expect(subject.age).to eq(34)
      end
    end

    context 'when there are not identification' do
      subject { create :boa_vista_acerta_essencial }

      it 'returns nil' do
        expect(subject.age).to be_nil
      end
    end
  end

  describe '#debit_approved?' do
    context 'when there are boa vista debit with disapproved word' do
      subject { create :boa_vista_acerta_essencial }

      let(:disapproved_word) do
        [
          'sinistro', 'imob', 'energia', 'eletrica', 'eletro',
          'companhia de energia', 'lojas cem', 'loja', 'havan', 'luizacred',
          'luiza', 'bahia', 'optica', 'otica', 'marisa', 'riachuelo',
          'lingerie', 'comercio', 'alianca', 'celpa', 'celpe', 'cemar', 'chesp',
          'cocel', 'coelba', 'cosern', 'cpfl', 'edp', 'elektro', 'eletropaulo',
          'enel', 'energisa', 'forcel', 'iguacu', 'jari', 'cesa', 'light',
          'muxfeldt', 'palma', 'panambi', 'rge', 'santa maria', 'luz', 'forca',
          'sulgipe', 'ceee-d', 'celesc', 'cemig', 'cerr', 'copel', 'eletrobras',
          'sicredi', 'cesta basica', 'cesta', 'telefonica', 'senffnet',
          'voxcred', 'nu financeira', 'nu', 'nu bank', 'mercado', 'mercadopago',
          'pago'
        ].sample
      end

      let!(:debit) do
        create :boa_vista_debit,
               informant: disapproved_word,
               boa_vista_acerta_essencial: subject
      end

      it 'returns false' do
        expect(subject.debit_approved?).to be(false)
      end
    end

    context 'when there are not boa vista debit with disapproved word' do
      subject { create :boa_vista_acerta_essencial }

      let!(:debit) do
        create :boa_vista_debit,
               informant: 'approved',
               boa_vista_acerta_essencial: subject
      end

      it 'returns true' do
        expect(subject.debit_approved?).to be(true)
      end
    end
  end
end
