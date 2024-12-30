# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_phones
#
#  id           :bigint           not null, primary key
#  region_code  :string
#  area_code    :string
#  phone_number :string
#  owner_type   :string
#  owner_id     :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
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
