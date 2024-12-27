# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_addresses
#
#  id                     :bigint           not null, primary key
#  address_line           :string
#  district               :string
#  zip_code               :string
#  country                :string
#  city                   :string
#  state                  :string
#  serasa_registration_id :bigint           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
module Serasa
  class Address < ApplicationRecord
    belongs_to :registration,
               class_name: 'Serasa::Registration',
               foreign_key: 'serasa_registration_id',
               inverse_of: :address

    validates :serasa_registration_id, uniqueness: true
  end
end
