# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_check_items
#
#  id              :bigint           not null, primary key
#  occurrence_date :date
#  legal_square    :string
#  bank_id         :integer
#  bank_name       :string
#  bank_agency_id  :integer
#  check_count     :integer
#  city            :string
#  federal_unit    :string
#  check_number    :string
#  alinea          :string
#  serasa_check_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
module Serasa
  class CheckItem < ApplicationRecord
    belongs_to :check,
               class_name: 'Serasa::Check',
               foreign_key: 'serasa_check_id',
               inverse_of: :items
  end
end
