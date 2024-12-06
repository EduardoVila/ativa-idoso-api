# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_negative_items
#
#  id              :bigint           not null, primary key
#  occurrence_date :date
#  legal_nature_id :string
#  legal_nature    :string
#  contract_id     :string
#  creditor_name   :string
#  amount          :float
#  city            :string
#  federal_unit    :string
#  principal       :boolean
#  owner_type      :string
#  owner_id        :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require_relative '../application_serializer'

module Serasa
  class NegativeItemSerializer < ApplicationSerializer
    attributes :occurrence_date, :value, :informant, :segment

    def informant
      object.creditor_name
    end

    def segment
      object.legal_nature
    end

    def value
      format('%.2f', object.amount)
    end
  end
end
