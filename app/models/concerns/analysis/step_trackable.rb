# frozen_string_literal: true

module Analysis
  module StepTrackable
    extend ActiveSupport::Concern
    included do
      def pending_analysis_steps
        executed_step_ids = item_steps.where(execution_status: :completed)
          .pluck(:analysis_step_id)

        Analysis::Step.enabled.order(:index_order)
          .where.not(id: executed_step_ids)
          .map(&:serialize_record)
      end

      def executed_analysis_steps
        steps.map(&:serialize_record)
      end

      def next_analysis_step
        return [] if pending_analysis_steps.empty?

        pending_analysis_steps.first
      end

      def last_analysis_executed_step
        return [] if steps.empty?

        steps.order(:index_order).last.serialize_record
      end

      def available_analysis_steps
        Analysis::Step.enabled.order(:index_order).map(&:serialize_record)
      end

      def steps_summary
        {
          pending_analysis_steps:,
          executed_analysis_steps:,
          last_analysis_executed_step:,
          next_analysis_step:,
          available_analysis_steps:
        }
      end
    end
  end
end
