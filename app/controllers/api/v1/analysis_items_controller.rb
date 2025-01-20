# frozen_string_literal: true

require_relative '../../application_controller'

module API
  module V1
    class AnalysisItemsController < ApplicationController
      include Sortable

      before %w[
        /api/v1/analysis-items/:analysis_item_id/next-steps
        /api/v1/:analysis_item_id/reruns
      ] do
        authenticate_access_token_from(request)
      end

      sorting(%w[index_order].freeze, default: { index_order: :asc })

      # Go to next analysis step
      post('/api/v1/analysis-items/:analysis_item_id/next-steps') do
        begin
          analysis_item = Analysis::Item.find(params['analysis_item_id'])
        rescue ActiveRecord::RecordNotFound
          return status(404)
        end

        body_params = JSON.parse(request.body.read)

        return status(400) if body_params['analysis_step_id'].blank?

        step_id = body_params['analysis_step_id']

        return status(400) if step_id.blank?

        analysis_item ||= Analysis::Item.find(params['analysis_item_id'])

        return status(422) if analysis_item.steps.find_by(id: step_id).present?

        AnalysisStepJob.perform_later(analysis_item.id, step_id)

        status(201)
      end

      # Rerun analysis item
      post('/api/v1/:analysis_item_id/reruns') do
        ClonedAnalysisItemJob.perform_later(params['analysis_item_id'])

        status(201)

        { message: 'Analysis item rerun scheduled' }.to_json
      end

      private

      def query_steps(analysis_item, options_params)
        Analysis::Step.where(id: analysis_item.steps.disabled&.pluck(:id))
          .or(
            Analysis::Step.where(enabled: true).where.not(
              index_order: analysis_item.steps.disabled&.pluck(:index_order)
            )
          ).order(sort_options(options_params))
      end
    end
  end
end
