# frozen_string_literal: true

require_relative '../../application_controller'

module API
  module V1
    class AnalysisItemsController < ApplicationController
      include Sortable

      sorting(%w[index_order].freeze, default: { index_order: :asc })

      post('/api/v1/analysis-items/:analysis_item_id/next-steps') do
        analysis_item = Analysis::Item.find_by(id: params['analysis_item_id'])

        halt(404) if analysis_item.blank?

        request.body.read.blank? ? halt(400) : request.body.rewind

        step_id = JSON.parse(request.body.read)['analysis_step_id']

        halt(400) if step_id.blank?

        halt(422) if analysis_item.steps.exists?(id: step_id)

        AnalysisStepJob.perform_later(analysis_item.id, step_id)

        status(202)
      end

      post('/api/v1/analysis-items/:analysis_item_id/reruns') do
        analysis_item = Analysis::Item.find_by(id: params['analysis_item_id'])

        halt(404) if analysis_item.blank?

        ClonedAnalysisItemJob.perform_later(params['analysis_item_id'])

        status(202)
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
