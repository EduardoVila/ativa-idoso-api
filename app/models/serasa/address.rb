# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_addresses
#
#  id                     :bigint           not null, primary key
#  address_line           :string
#  city                   :string
#  country                :string
#  district               :string
#  state                  :string
#  zip_code               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  serasa_registration_id :bigint           not null
#
# Indexes
#
#  index_serasa_addresses_on_serasa_registration_id  (serasa_registration_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_registration_id => serasa_registrations.id)
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
