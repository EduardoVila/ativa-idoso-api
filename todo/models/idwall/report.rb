# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_reports
#
#  id         :bigint           not null, primary key
#  number     :string           not null
#  status     :integer          default("processing")
#  raw_data   :string
#  score_id   :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module Idwall
  class Report < ApplicationRecord
    enum status: { processing: 0, processed: 1 }

    validates :number, presence: true

    belongs_to :score

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

    delegate :name, to: :cpf

    def approved?
      checked_trials = trials.includes(:trial_parts).map(
        &:defendant_and_disapproved?
      )

      checked_trials.exclude? true
    end
  end
end
