# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_scores
#
#  id                       :bigint           not null, primary key
#  score                    :integer
#  score_model              :string
#  range                    :string
#  default_rate             :string
#  code_message             :integer
#  message                  :string
#  serasa_fintech_report_id :bigint           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
module Serasa
  class Score < ApplicationRecord
    belongs_to :fintech_report,
               class_name: 'Serasa::FintechReport',
               foreign_key: 'serasa_fintech_report_id',
               inverse_of: :score
  end
end
