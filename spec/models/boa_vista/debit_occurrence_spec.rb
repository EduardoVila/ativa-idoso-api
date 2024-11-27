# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_debit_occurrences
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  total_debtor                  :string
#  total_guarantor               :string
#  accumulated_value             :string
#  first_debit_date              :string
#  first_debit_value             :string
#  biggest_debit_date            :string
#  biggest_debit_value           :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
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
