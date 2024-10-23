# frozen_string_literal: true

module Analysis
  class ItemStep < ApplicationRecord
    belongs_to :item, class_name: 'Analysis::Item'
    belongs_to :step, class_name: 'Analysis::Step'
  end
end
