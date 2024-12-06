# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_protested_titles
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  occurrence_type               :string
#  registry                      :string
#  occurrence_date               :string
#  currency                      :string
#  value                         :string
#  city                          :string
#  federative_unit               :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
require_relative '../application_serializer'

module BoaVista
  class ProtestedTitleSerializer < ApplicationSerializer
    attributes :occurrence_type, :occurrence_date, :registry, :value,
               :city, :federative_unit

    def value
      object.value.delete('.').tr(',', '.').to_f
    end

    def occurrence_date
      object.occurrence_date.to_date
    end
  end
end
