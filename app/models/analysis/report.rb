# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_reports
#
#  id                    :bigint           not null, primary key
#  approved              :boolean
#  cpfs                  :string           is an Array
#  disapproval_situation :integer
#  fee                   :float
#  payload               :string
#  status                :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  api_client_id         :bigint           not null
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
require_relative '../concerns/disapproval_situation_concern'
module Analysis
  class Report < ApplicationRecord
    include ::AnalysisReportFeeComputable
    include ::Auditable
    include ::DisapprovalSituationConcern

    auditable ignore: %i[payload status created_at updated_at]

    before_validation :format_cpfs

    enum :status, %i[todo wip done not_found error]

    validates :status, inclusion: { in: statuses.keys }
    validates :disapproval_situation,
              inclusion: { in: disapproval_situations.keys },
              allow_nil: true
    validate :cpfs_validation

    belongs_to :api_client, class_name: 'API::Client',
                            foreign_key: 'api_client_id'

    has_many :items, class_name: 'Analysis::Item',
                     inverse_of: :report,
                     dependent: :destroy

    scope :approved, -> { where(approved: true) }

    private

    def format_cpfs
      return if cpfs.blank?

      self.cpfs = cpfs.map do |cpf|
        CPF::Formatter.format cpf
      end
    end

    def cpfs_validation
      return if cpfs.blank?

      cpfs.each do |cpf|
        next if CPF.valid? cpf

        errors.add(:cpfs, message: cpf)
      end
    end
  end
end
