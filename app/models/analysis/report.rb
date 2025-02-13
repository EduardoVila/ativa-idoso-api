# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_reports
#
#  id                    :uuid             not null, primary key
#  approved              :boolean
#  cpfs                  :string           is an Array
#  disapproval_situation :integer
#  fee                   :float
#  payload               :string
#  status                :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  api_client_id         :uuid             not null
#
# Indexes
#
#  index_analysis_reports_on_api_client_id  (api_client_id)
#
# Foreign Keys
#
#  fk_rails_...  (api_client_id => api_clients.id)
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
      :reproved_by_obit_indication,
      :prediction
    ]

    belongs_to :api_client, class_name: 'API::Client',
                            foreign_key: 'api_client_id'

    has_many :items, class_name: 'Analysis::Item',
                     inverse_of: :report,
                     dependent: :destroy

    validate :cpfs_validation

    scope :approved, -> { where(approved: true) }

    private

    def cpfs_validation
      return if cpfs.blank?

      cpfs.each do |cpf|
        cpf = CPF::Formatter.format cpf

        next if CPF.valid? cpf

        errors.add(:cpfs, message: cpf)
      end
    end
  end
end
