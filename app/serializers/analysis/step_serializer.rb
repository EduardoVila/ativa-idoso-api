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
    attributes :id, :name, :formatted_name, :command_class, :index_order

    def formatted_name
      I18n.t("activemodel.models.score_step.attributes.name.#{object.name}")
    end
  end
end
