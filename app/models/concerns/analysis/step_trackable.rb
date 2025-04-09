# frozen_string_literal: true

module Analysis
  module StepTrackable
    extend ActiveSupport::Concern
    included do
      def pending_steps
        all_possible_steps = Analysis::Step.enabled.order(:index_order)
        executed_step_ids = steps.pluck(:id)

        all_possible_steps.reject { |step| executed_step_ids.include?(step.id) }
      end

      def executed_steps
        steps.includes(:item_steps).order('analysis_steps.index_order')
      end

      def next_step
        pending_steps.first
      end

      def steps_execution_summary
        {
          total_steps: Analysis::Step.enabled.count,
          executed_steps: executed_steps.count,
          pending_steps: pending_steps.count,
          last_executed_step: executed_steps.last&.name,
          next_step: next_step&.name,
          possible_steps_with_status: possible_steps_with_status,
          execution_order: execution_order_data,
          percent_complete: calculate_percent_complete
        }
      end

      private

      def calculate_percent_complete
        total = Analysis::Step.enabled.count
        return 0 if total.zero?

        ((executed_steps.count.to_f / total) * 100).round(2)
      end

      def execution_order_data
        ordered_steps = collect_executed_steps_data
        add_execution_position(ordered_steps)
        ordered_steps
      end

      def collect_executed_steps_data
        item_steps.includes(:step)
          .order('analysis_item_steps.created_at')
          .map { |item_step| build_step_data(item_step) }
      end

      def build_step_data(item_step)
        {
          id: item_step.step.id,
          name: item_step.step.name,
          index_order: item_step.step.index_order,
          status: item_step.execution_status,
          started_at: item_step.started_at,
          finished_at: item_step.finished_at,
          duration: item_step.duration,
          execution_position: nil
        }
      end

      def add_execution_position(steps_data)
        steps_data.each_with_index do |step_data, index|
          step_data[:execution_position] = index + 1
        end
      end

      def step_status(step)
        item_step = item_steps.find_by(analysis_step_id: step.id)
        return :pending unless item_step

        item_step.execution_status.to_sym
      end

      def possible_steps_with_status
        steps_status = {}

        Analysis::Step.enabled.each do |step|
          steps_status[step.name] = step_status(step)
        end

        steps_status
      end
    end
  end
end
