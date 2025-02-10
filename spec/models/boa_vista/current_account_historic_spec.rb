# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_current_account_historics
#
#  id                            :bigint           not null, primary key
#  agency                        :string
#  bank                          :string
#  consultation_date             :string
#  consultation_hour             :string
#  current_account               :string
#  document_number               :string
#  document_type                 :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_current_account_historic_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
require 'spec_helper'

RSpec.describe BoaVista::CurrentAccountHistoric, type: :model do
  describe 'factories' do
    subject { build :boa_vista_current_account_historic }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
