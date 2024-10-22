# frozen_string_literal: true

module Analysis
  class Report < ApplicationRecord
    belongs_to :api_client, class_name: 'API::Client'
    has_many :items, class_name: 'Analysis::Item'
  end
end
