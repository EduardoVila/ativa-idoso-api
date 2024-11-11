# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoaVista::Debit, type: :model do
  describe 'factories' do
    subject { build :boa_vista_debit }

    it { is_expected.to be_valid }
  end

  context 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial) }
  end

  describe 'scopes' do
    describe 'current_semester' do
      let!(:current_semester_item) do
        create(
          :boa_vista_debit,
          occurrence_date: Time.zone.today.strftime('%d/%m/%Y')
        )
      end

      before do
        create(
          :boa_vista_debit,
          occurrence_date: (Time.zone.today - 7.months).strftime('%d/%m/%Y')
        )
      end

      it 'returns items filtered by occurrence date of current semester' do
        expect(described_class.current_semester)
          .to contain_exactly(current_semester_item)
      end
    end
  end

  describe '#disapproved?' do
    context 'when is disapproved' do
      subject { create :boa_vista_debit, informant: 'SINISTRO' }

      it 'returns true' do
        expect(subject).to be_disapproved
      end
    end

    context 'when is approved' do
      subject { create :boa_vista_debit, informant: 'FOO' }

      it 'returns false' do
        expect(subject).not_to be_disapproved
      end
    end
  end
end
