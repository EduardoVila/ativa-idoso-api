# frozen_string_literal: true

module Analysis
  class ItemStepSerializer < ApplicationSerializer
    attributes :id, :execution_status, :result_summary, :started_at,
               :finished_at, :duration, :created_at, :updated_at,
               :analysis_item_id, :analysis_step_id
  end
end
