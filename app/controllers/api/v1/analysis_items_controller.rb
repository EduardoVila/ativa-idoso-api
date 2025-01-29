# frozen_string_literal: true

require_relative '../../application_controller'

module API
  module V1
    class AnalysisItemsController < ApplicationController
      include Sortable

      sorting(%w[index_order].freeze, default: { index_order: :asc })

      post('/api/v1/analysis-items/next-steps') do
        current_client = Tokenable.current_client(request)

        halt(401) if current_client.blank?

        request.body.read.blank? ? halt(400) : request.body.rewind

        request_body = JSON.parse(request.body.read)

        step_id = request_body['analysis_step_id']
        cpf = request_body['cpf']

        halt(400) if step_id.blank? || cpf.blank?

        analysis_item = Analysis::Item.where(cpf: cpf)
          .order(updated_at: :desc)
          .first

        halt(404) if analysis_item.blank?

        api_client_id = analysis_item.report.api_client_id

        halt(403) if api_client_id != current_client.id

        halt(422) if analysis_item.steps.exists?(id: step_id)

        AnalysisStepJob.perform_later(analysis_item.id, step_id)

        status(202)
      end

      post('/api/v1/analysis-items/reruns') do
        current_client = Tokenable.current_client(request)

        halt(401) if current_client.blank?

        request.body.read.blank? ? halt(400) : request.body.rewind

        request_body = JSON.parse(request.body.read)
        cpf = request_body['cpf']

        halt(400) if cpf.blank?

        analysis_item = Analysis::Item.where(cpf: cpf)
          .order(updated_at: :desc)
          .first

        halt(404) if analysis_item.blank?

        api_client_id = analysis_item.report.api_client_id

        halt(403) if api_client_id != current_client.id

        ClonedAnalysisItemJob.perform_later(analysis_item.id)

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
