# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_debits
#
#  id                            :bigint           not null, primary key
#  availability_date             :string
#  condition                     :string
#  contract                      :string
#  currency                      :string           default("0")
#  informant                     :string
#  informed_by_querent           :string
#  occurrence_date               :string
#  occurrence_type               :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  segment                       :string
#  value                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_debits_on_boa_vista_acerta_essencial_id  (boa_vista_acerta_essencial_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
