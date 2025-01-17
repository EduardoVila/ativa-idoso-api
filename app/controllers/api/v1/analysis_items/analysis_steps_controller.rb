# frozen_string_literal: true

require_relative '../../../application_controller'

module API
  module V1
    module AnalysisItems
      class AnalysisStepsController < ApplicationController
        include Sortable

        before(%w[/api/v1/analysis-items/:analysis_item_id/steps]) do
          authenticate_access_token_from(request)
        end

        sorting(%w[index_order].freeze, default: { index_order: :asc })

        # Index
        # get('/api/v1/analysis-items/:analysis_item_id/steps') do
        #   begin
        #     analysis_item = Analysis::Item.find(params['analysis_item_id'])
        #   rescue ActiveRecord::RecordNotFound
        #     return status(404)
        #   end

        #   options_params = extract_options_params(request)

        #   analysis_steps = query_steps(analysis_item, options_params)

        #   analysis_steps.map do |analysis_step|
        #     analysis_step.serialize_record(with: Analysis::StepSerializer)
        #   end
        # end

        # Create
        post('/api/v1/analysis-items/:analysis_item_id/steps') do
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

          if analysis_item.steps.find_by(id: step_id).present?
            return status(422)
          end

          AnalysisStepJob.perform_later(analysis_item.id, step_id)

          status(201)
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
end
