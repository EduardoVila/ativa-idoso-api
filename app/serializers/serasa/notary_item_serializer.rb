# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_notary_items
#
#  id               :bigint           not null, primary key
#  occurrence_date  :date
#  amount           :float
#  office_number    :string
#  office_name      :string
#  city             :string
#  federal_unit     :string
#  serasa_notary_id :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require_relative '../application_serializer'

module Serasa
  class NotaryItemSerializer < ApplicationSerializer
    attributes :occurrence_date, :value, :office_number, :office_name, :city,
               :federal_unit

    def value
      format('%.2f', object.amount)
    end
  end
end
