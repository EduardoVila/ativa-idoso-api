# frozen_string_literal: true

module Analysis
  class StepSerializer < ApplicationSerializer
    attributes :id, :name, :formatted_name, :command_class, :index_order

    def formatted_name
      I18n.t("activemodel.models.score_step.attributes.name.#{object.name}")
    end
  end
end
