# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_phones
#
#  id                              :uuid             not null, primary key
#  ddd                             :string
#  number                          :string
#  phone_type                      :string
#  boa_vista_cadastral_location_id :uuid             not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
module BoaVista
  class Phone < ApplicationRecord
    belongs_to :boa_vista_cadastral_location,
               class_name: 'BoaVista::CadastralLocation',
               inverse_of: :phones

    alias_attribute :numero, :number
    alias_attribute :tipo, :phone_type
  end
end
