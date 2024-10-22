# frozen_string_literal: true

module API
  class Client < ApplicationRecord
    has_many :analysis_reports, class_name: 'Analysis::Report'
  end
end
