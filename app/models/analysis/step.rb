# frozen_string_literal: true

module Analysis
  class Step < ApplicationRecord
    has_many :item_steps, class_name: 'Analysis::ItemStep', dependent: :destroy
    has_many :items, through: :item_steps, class_name: 'Analysis::Item'
  end
end
