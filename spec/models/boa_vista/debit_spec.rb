# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_debits
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  occurrence_type               :string
#  occurrence_date               :string
#  contract                      :string
#  availability_date             :string
#  currency                      :string           default("0")
#  value                         :string
#  condition                     :string
#  informant                     :string
#  segment                       :string
#  informed_by_querent           :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
require 'spec_helper'

RSpec.describe BoaVista::Debit, type: :model do
  describe 'factories' do
    subject { build :boa_vista_debit }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
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
