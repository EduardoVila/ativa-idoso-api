# frozen_string_literal: true

require_relative '../../../application_controller'

module API
  module V1
    module AnalysisItems
      class AnalysisStepsController < ApplicationController
        include Sortable

        before(%w[/api/v1/steps /api/v1/steps/:id /api/v1/steps]) do
          authenticate_access_token_from request
        end

        sorting(%w[index_order].freeze, default: { index_order: :asc })

        # def index
        #   render json: serialized_analysis_steps
        # end

        # def show
        #   render json: serialized_analysis_step.merge({ data: analysis_step_data })
        # end

        # def create
        #   return status(422) if analysis_step_present?

        #   PerformScoreStepService.call(score, analysis_step)

        #   head :ok
        # end

        # Index route
        get('/api/v1/steps') do
        end

        # Show route
        get('/api/v1/steps/:id') do
          body_params = JSON.parse(request.body.read)
          analysis_item ||= Analysis::Item.find(body_params['analysis_item_id'])
        end

        # Create route
        post('/api/v1/analysis-items/:analysis_item_id/steps') do
          body_params = JSON.parse(request.body.read)
          step_id = body_params['analysis_step_id']

          analysis_item ||= Analysis::Item.find(params['analysis_item_id'])

          if analysis_item.steps.find_by(id: step_id).present?
            return status(422)
          end

          AnalysisStepJob.perform_later(analysis_item.id, step_id)

          status(201)
        end

        private

        def analysis_step_data
          step_name = @analysis_step.name

          if @analysis_step.internal_processing_step? ||
             !@score.respond_to?(step_name)
            return @score.serialize_record(with: Admins::ScoreSerializer)
          end

          score_relation = @score.send(step_name)

          if score_relation.is_a?(ActiveRecord::Associations::CollectionProxy)
            return score_relation.map(&:serialize_record)
          end

          score_relation&.serialize_record
        end

        def analysis_step
          @analysis_step ||= ScoreStep.find(
            create_permitted_params[:analysis_step_id] ||
            show_permitted_params[:id]
          )
        end

        def analysis_steps
          @analysis_steps ||= Analysis::Step.where(
            id: @analysis_item.steps.disabled.pluck(:id)
          )
            .or(
              ScoreStep.where(enabled: true).where.not(
                index_order: @score.steps.disabled.pluck(:index_order)
              )
            ).order(sort_options)
        end

        def serialized_analysis_step
          @analysis_step.serialize_record
        end

        def serialized_analysis_steps
          @analysis_steps.map do |analysis_step|
            analysis_step.serialize_record(with: Collections::ScoreStepSerializer)
          end
        end

        def show_permitted_params
          params.permit(:score_id, :id)
        end

        def create_permitted_params
          params.permit(:score_id, :analysis_step_id)
        end
      end
    end
  end
end
