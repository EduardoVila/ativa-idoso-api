# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_check_items
#
#  id              :bigint           not null, primary key
#  alinea          :string
#  bank_name       :string
#  check_count     :integer
#  check_number    :string
#  city            :string
#  federal_unit    :string
#  legal_square    :string
#  occurrence_date :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  bank_agency_id  :integer
#  bank_id         :integer
#  serasa_check_id :bigint           not null
#
# Indexes
#
#  index_serasa_check_items_on_serasa_check_id  (serasa_check_id)
#
# Foreign Keys
#
#  fk_rails_...  (serasa_check_id => serasa_checks.id)
#
module Serasa
  class CheckItem < ApplicationRecord
    belongs_to :check,
               class_name: 'Serasa::Check',
               foreign_key: 'serasa_check_id',
               inverse_of: :items
  end
end
