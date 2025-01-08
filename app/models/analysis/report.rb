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
#  payload               :string
#  api_client_id         :uuid             not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
require_relative '../concerns/analysis_report_fee_computable'

module Analysis
  class Report < ApplicationRecord
    include ::AnalysisReportFeeComputable

    auditable ignore: %i[payload status created_at updated_at]

    enum :status, %i[todo wip done not_found error]
    enum :disapproval_situation, [
      :debtor, # when has debits with Alpop
      :blocked_negativity,
      :reproved_by_trial,
      :insufficient_income,
      :exceeded_debits,
      :blocked_cpf,
      :reproved_by_relative,
      :reproved_by_bounced_check,
      :reproved_by_age_and_income,
      :reproved_by_obit_indication
    ]

    belongs_to :api_client, class_name: 'API::Client',
                            foreign_key: 'api_client_id'

    has_many :items, class_name: 'Analysis::Item',
                     inverse_of: :report,
                     dependent: :destroy

    scope :approved, -> { where(approved: true) }
  end
end
