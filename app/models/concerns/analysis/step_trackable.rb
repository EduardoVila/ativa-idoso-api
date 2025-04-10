# frozen_string_literal: true

module Analysis
  module StepTrackable
    extend ActiveSupport::Concern
    included do
      def pending_steps
        executed_step_ids = item_steps.where(execution_status: :completed)
          .pluck(:analysis_step_id)

        Analysis::Step.enabled.order(:index_order)
          .where.not(id: executed_step_ids)
          .map(&:serialize_record)
      end

      def next_step
        return [] if pending_steps.empty?

        pending_steps.first
      end

      def last_executed_step
        return [] if steps.empty?

        steps.order(:index_order).last.serialize_record
      end

      def all_possible_step
        Analysis::Step.enabled.order(:index_order).map(&:serialize_record)
      end

      def steps_summary
        {
          pending_steps: pending_steps,
          last_executed_step: last_executed_step,
          next_step: next_step,
          all_possible_step: all_possible_step
        }
      end
    end
  end
end
