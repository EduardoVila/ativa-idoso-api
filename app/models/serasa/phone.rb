# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_phones
#
#  id           :bigint           not null, primary key
#  area_code    :string
#  owner_type   :string
#  phone_number :string
#  region_code  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  owner_id     :bigint
#
# Indexes
#
#  index_serasa_phones_on_owner  (owner_type,owner_id) UNIQUE
#
module Serasa
  class Phone < ApplicationRecord
    belongs_to :owner,
               polymorphic: true,
               foreign_type: :owner_type,
               inverse_of: :phone

    validates :owner_id, uniqueness: { scope: :owner_type }
  end
end
