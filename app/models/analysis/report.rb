# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_reports
#
#  id                    :uuid             not null, primary key
#  cpfs                  :string           is an Array
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
    enum status: { todo: 0, wip: 1, done: 2, not_found: 3, error: 4 }
    enum disapproval_situation: {
      debtor: 1, # when has debits with Alpop
      blocked_negativity: 2,
      reproved_by_trial: 3,
      insufficient_income: 4,
      exceeded_debits: 5,
      blocked_cpf: 6,
      reproved_by_relative: 7,
      reproved_by_bounced_check: 8,
      reproved_by_age_and_income: 9,
      reproved_by_obit_indication: 10
    }

    belongs_to :api_client, class_name: 'API::Client',
                            foreign_key: 'api_client_id'

    has_many :items, class_name: 'Analysis::Item',
                     inverse_of: :report,
                     dependent: :destroy

    scope :approved, -> { where(approved: true) }
  end
end
