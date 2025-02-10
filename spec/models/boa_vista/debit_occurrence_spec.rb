# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_debit_occurrences
#
#  id                            :bigint           not null, primary key
#  accumulated_value             :string
#  biggest_debit_date            :string
#  biggest_debit_value           :string
#  first_debit_date              :string
#  first_debit_value             :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  total_debtor                  :string
#  total_guarantor               :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_debit_occurrences_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
require 'spec_helper'

RSpec.describe BoaVista::DebitOccurrence, type: :model do
  describe 'factories' do
    subject { build :boa_vista_debit_occurrence }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
