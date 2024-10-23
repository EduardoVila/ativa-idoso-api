# frozen_string_literal: true

# == Schema Information
#
# Table name: api_clients
#
#  id            :uuid             not null, primary key
#  client_id     :string
#  client_secret :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
module API
  class Client < ApplicationRecord
    has_many :analysis_reports, class_name: 'Analysis::Report'
  end
end
