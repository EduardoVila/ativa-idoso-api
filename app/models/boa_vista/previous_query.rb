# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_previous_queries
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  occurrence_type               :string
#  date                          :string
#  currency                      :string
#  value                         :string
#  informant                     :string
#  product                       :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
module BoaVista
  class PreviousQuery < ApplicationRecord
    belongs_to :boa_vista_acerta_essencial,
               class_name: 'BoaVista::AcertaEssencial',
               inverse_of: :previous_queries
  end
end
