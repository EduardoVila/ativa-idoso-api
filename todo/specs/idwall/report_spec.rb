# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Idwall::Report, type: :model do
  describe 'factories' do
    subject { build :idwall_report }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    context 'number' do
      it { is_expected.to validate_presence_of :number }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:score) }

    it { is_expected.to have_one(:cpf) }
    it { is_expected.to have_many(:trials) }
    it { is_expected.to have_many(:addresses) }
    it { is_expected.to have_many(:related_people) }
  end

  describe '#approved?' do
    context 'when have unapproved trial' do
      subject { create :idwall_report }

      let(:trial) { create :idwall_trial, idwall_report: subject }
      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: trial,
          title: 'REQDO',
          name: 'eduardo de vila'
        )
      end

      it 'returns false' do
        expect(subject).not_to be_approved
      end
    end

    context 'when have approved trial' do
      subject { create :idwall_report }

      let(:trial) do
        create(
          :idwall_trial,
          idwall_report: subject,
          subject: 'Bla bla',
          kind: 'Bla bla'
        )
      end
      let!(:cpf) do
        create(
          :idwall_cpf,
          idwall_report: subject,
          name: 'EDUARDO DE VILA'
        )
      end
      let!(:trial_part) do
        create(
          :idwall_trial_part,
          idwall_trial: trial,
          title: 'REQTE',
          name: 'eduardo de vila'
        )
      end
      let!(:trial_part1) do
        create(
          :idwall_trial_part,
          idwall_trial: trial,
          title: 'REQUERIDO',
          name: 'João Manoel'
        )
      end

      it 'returns true' do
        expect(subject).to be_approved
      end
    end
  end
end
