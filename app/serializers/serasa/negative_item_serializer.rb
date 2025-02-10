# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_negative_items
#
#  id              :bigint           not null, primary key
#  amount          :float
#  city            :string
#  creditor_name   :string
#  federal_unit    :string
#  legal_nature    :string
#  occurrence_date :date
#  owner_type      :string
#  principal       :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  contract_id     :string
#  legal_nature_id :string
#  owner_id        :bigint
#
# Indexes
#
#  index_serasa_negative_items_on_owner  (owner_type,owner_id)
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
