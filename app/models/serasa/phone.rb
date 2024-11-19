# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_phones
#
#  id           :uuid             not null, primary key
#  region_code  :string
#  area_code    :string
#  phone_number :string
#  owner_type   :string
#  owner_id     :uuid
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
module Serasa
  class Phone < ApplicationRecord
    belongs_to :owner,
               polymorphic: true,
               foreign_type: :owner_type,
               inverse_of: :phone
  end
end
