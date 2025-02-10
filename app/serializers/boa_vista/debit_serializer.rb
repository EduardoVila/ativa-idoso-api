# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_debits
#
#  id                            :bigint           not null, primary key
#  availability_date             :string
#  condition                     :string
#  contract                      :string
#  currency                      :string           default("0")
#  informant                     :string
#  informed_by_querent           :string
#  occurrence_date               :string
#  occurrence_type               :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  segment                       :string
#  value                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_debits_on_boa_vista_acerta_essencial_id  (boa_vista_acerta_essencial_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
