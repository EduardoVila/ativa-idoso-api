# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_reports
#
#  id                    :uuid             not null, primary key
#  cpf                   :string
#  status                :integer
#  fee                   :float
#  approved              :boolean
#  disapproval_situation :integer
#  api_client_id         :uuid             not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
module Analysis
  class Report < ApplicationRecord
    belongs_to :api_client, class_name: 'API::Client'
    has_many :items, class_name: 'Analysis::Item'
  end
end
