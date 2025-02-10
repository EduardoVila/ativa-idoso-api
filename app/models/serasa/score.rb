# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_scores
#
#  id                       :bigint           not null, primary key
#  code_message             :integer
#  default_rate             :string
#  message                  :string
#  range                    :string
#  score                    :integer
#  score_model              :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  serasa_fintech_report_id :bigint           not null
#
# Indexes
#
#  index_serasa_scores_on_serasa_fintech_report_id  (serasa_fintech_report_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_fintech_report_id => serasa_fintech_reports.id)
#
module Serasa
  class Score < ApplicationRecord
    belongs_to :fintech_report,
               class_name: 'Serasa::FintechReport',
               foreign_key: 'serasa_fintech_report_id',
               inverse_of: :score

    validates :serasa_fintech_report_id, uniqueness: true
  end
end
