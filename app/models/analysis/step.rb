# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_steps
#
#  id            :bigint           not null, primary key
#  name          :string
#  command_class :string
#  index_order   :integer
#  enabled       :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
module Analysis
  class Step < ApplicationRecord
    has_many :item_steps,
             class_name: 'Analysis::ItemStep',
             inverse_of: :step,
             dependent: :destroy

    has_many :items, through: :item_steps,
                     class_name: 'Analysis::Item',
                     inverse_of: :steps

    with_options presence: true do
      validates :name
      validates :command_class
      validates :index_order
    end

    scope :enabled, -> { where enabled: true }
    scope :disabled, -> { where enabled: false }

    def internal_processing_step?
      name.include?('alpop')
    end

    private

    def validate_command_class
      Module.const_get(command_class) if command_class.present?
    rescue NameError
      errors.add(:command_class, :not_found)
    end
  end
end
