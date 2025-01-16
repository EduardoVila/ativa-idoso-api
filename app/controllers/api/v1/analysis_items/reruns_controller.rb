# frozen_string_literal: true

require_relative '../../../application_controller'

module API
  module V1
    module AnalysisItems
      class RerunsController < ApplicationController
        before('/api/v1/:analysis_item_id/rerun') do
          authenticate_access_token_from request
        end

        post('/api/v1/:analysis_item_id/rerun') do
          ClonedAnalysisItemJob.perform_later(params['analysis_item_id'])

          status(201)

          { message: 'Analysis item rerun scheduled' }.to_json
        end
      end
    end
  end
end
