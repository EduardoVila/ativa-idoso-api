# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_phones
#
#  id                              :bigint           not null, primary key
#  ddd                             :string
#  number                          :string
#  phone_type                      :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  boa_vista_cadastral_location_id :bigint
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
