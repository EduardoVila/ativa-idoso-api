# frozen_string_literal: true

module Analysis
  class ItemStepSerializer < ApplicationSerializer
    attributes :id, :execution_status, :result_summary, :started_at,
               :finished_at, :duration, :created_at, :updated_at,
               :analysis_item_id, :analysis_step_id

    def formatted_name
      I18n.t("activemodel.models.score_step.attributes.name.#{object.name}")
    end
  end
end
