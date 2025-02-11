# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_reports
#
#  id                    :uuid             not null, primary key
#  approved              :boolean
#  cpfs                  :string           is an Array
#  disapproval_situation :integer
#  fee                   :float
#  payload               :string
#  status                :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  api_client_id         :uuid             not null
#
# Indexes
#
#  index_analysis_reports_on_api_client_id  (api_client_id)
#
# Foreign Keys
#
#  fk_rails_...  (api_client_id => api_clients.id)
#
require_relative '../application_serializer'

module Analysis
  class ReportSerializer < ApplicationSerializer
    attributes :id, :cpfs, :status, :result, :valid_until,
               :created_by, :created_at, :fee, :items

    def items
      object.items.map do |analysis_item|
        analysis_item.serialize_record(
          with: Analysis::ItemSerializer
        )
      end
    end

    def valid_until
      object.created_at + 30.days
    end

    def created_by
      object.api_client.client_id
    end

    def result
      return {} if object.status != 'done'

      {
        approved: object.approved,
        disapproval_situation: object.disapproval_situation
      }
    end
  end
end
