# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_steps
#
#  id            :bigint           not null, primary key
#  command_class :string
#  enabled       :boolean          default(TRUE)
#  index_order   :integer
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
module Analysis
  class StepSerializer < ApplicationSerializer
    attributes :id, :name, :formatted_name, :command_class, :index_order,
               :item_steps

    def formatted_name
      I18n.t("activemodel.models.item_step.attributes.name.#{object.name}")
    end

    def item_steps
      object.item_steps.includes(:item).map do |item_step|
        item_step.serialize_record(
          with: Analysis::ItemStepSerializer
        )
      end
    end
  end
end
