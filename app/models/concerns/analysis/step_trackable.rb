# frozen_string_literal: true

module Analysis
  module StepTrackable
    extend ActiveSupport::Concern

    included do
      def available_analysis_steps
        Analysis::Step.enabled.order(:index_order).map(&:serialize_record)
      end

      def executed_analysis_steps
        steps.map(&:serialize_record)
      end

      def pending_analysis_steps
        available_analysis_steps - executed_analysis_steps
      end

      def next_analysis_step
        return [] if pending_analysis_steps.empty?

        pending_analysis_steps.first
      end

      def last_analysis_executed_step
        return [] if steps.empty?

        executed_analysis_steps.last
      end

      def steps_summary
        {
          available_analysis_steps:,
          executed_analysis_steps:,
          pending_analysis_steps:,
          next_analysis_step:,
          last_analysis_executed_step:
        }
      end

      def update_steps_data
        update(steps_data: steps_summary)
      end
    end
  end
end
