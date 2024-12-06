# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_debits
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  occurrence_type               :string
#  occurrence_date               :string
#  contract                      :string
#  availability_date             :string
#  currency                      :string           default("0")
#  value                         :string
#  condition                     :string
#  informant                     :string
#  segment                       :string
#  informed_by_querent           :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
require_relative '../application_serializer'

module BoaVista
  class DebitSerializer < ApplicationSerializer
    attributes :occurrence_date, :value, :informant, :segment

    def value
      object.value.delete('.').tr(',', '.').to_f
    end

    def occurrence_date
      object.occurrence_date.to_date
    end
  end
end
