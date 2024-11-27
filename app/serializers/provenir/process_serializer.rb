# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_processes
#
#  id                        :bigint           not null, primary key
#  lawsuits_total            :integer
#  defendant_lawsuits_total  :integer
#  plaintiff_lawsuits_total  :integer
#  provenir_big_data_corp_id :bigint           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
require_relative '../application_serializer'

module Provenir
  class ProcessSerializer < ApplicationSerializer
    attributes :id, :lawsuits_total, :lawsuits

    def lawsuits
      object.lawsuits.map do |lawsuit|
        lawsuit.serialize_record(with: Provenir::LawsuitSerializer)
      end
    end
  end
end
