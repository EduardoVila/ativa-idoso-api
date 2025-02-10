# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_reports
#
#  id               :bigint           not null, primary key
#  number           :string           not null
#  raw_data         :string
#  status           :integer          default("processing")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  analysis_item_id :uuid             not null
#
# Indexes
#
#  index_idwall_reports_on_analysis_item_id  (analysis_item_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (analysis_item_id => analysis_items.id)
#
module Idwall
  class Report < ApplicationRecord
    enum :status, %i[processing processed]

    belongs_to :analysis_item, class_name: 'Analysis::Item',
                               foreign_key: 'analysis_item_id',
                               inverse_of: :idwall_report

    has_one :cpf, class_name: 'Idwall::CPF',
                  dependent: :destroy,
                  foreign_key: 'idwall_report_id',
                  inverse_of: :idwall_report

    has_many :trials, class_name: 'Idwall::Trial',
                      dependent: :destroy,
                      foreign_key: 'idwall_report_id',
                      inverse_of: :idwall_report

    has_many :addresses, class_name: 'Idwall::Address',
                         dependent: :destroy,
                         foreign_key: 'idwall_report_id',
                         inverse_of: :idwall_report

    has_many :related_people, class_name: 'Idwall::RelatedPerson',
                              dependent: :destroy,
                              foreign_key: 'idwall_report_id',
                              inverse_of: :idwall_report

    validates :number, presence: true
    validates :analysis_item_id, uniqueness: true

    delegate :name, to: :cpf

    def approved?
      checked_trials = trials.includes(:trial_parts).map(
        &:defendant_and_disapproved?
      )

      checked_trials.exclude? true
    end
  end
end
