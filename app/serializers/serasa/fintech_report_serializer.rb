# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_fintech_reports
#
#  id               :bigint           not null, primary key
#  raw_data         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  analysis_item_id :uuid             not null
#
# Indexes
#
#  index_serasa_fintech_reports_on_analysis_item_id  (analysis_item_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (analysis_item_id => analysis_items.id)
#
require_relative '../application_serializer'

module Serasa
  class FintechReportSerializer < ApplicationSerializer
    attributes :id, :created_at, :debits, :notaries

    def debits
      return [] if negative_data.blank?

      debits_data.map(&:serialize_record)
    end

    def notaries
      return [] if negative_data.blank?

      notaries_data.map(&:serialize_record)
    end

    private

    def negative_data
      object.negative_data
    end

    def debits_data
      negative_data.debits
    end

    def notaries_data
      negative_data.notaries
    end
  end
end
