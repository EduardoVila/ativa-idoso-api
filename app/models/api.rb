# frozen_string_literal: true

require_relative 'application_record'

module API
  def self.table_name_prefix
    'api_'
  end
end
