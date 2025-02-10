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
#  boa_vista_cadastral_location_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_phones_on_boa_vista_cadastral_location_id  (boa_vista_cadastral_location_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_cadastral_location_id => boa_vista_cadastral_locations.id)
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
