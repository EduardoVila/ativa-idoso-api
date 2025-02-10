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

RSpec.describe BoaVista::DebitSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:debit) { build :boa_vista_debit }
  let(:serializer) { described_class.new debit }

  it { is_expected.to serialize_attribute(:informant).from(debit) }
  it { is_expected.to serialize_attribute(:segment).from(debit) }

  describe 'custom attributes' do
    describe '#value' do
      subject { serialized[:value] }

      it { is_expected.to eq(debit.value.to_f) }
    end

    describe '#occurrence_date' do
      subject { serialized[:occurrence_date] }

      it { is_expected.to eq(debit.occurrence_date.to_date) }
    end
  end
end
