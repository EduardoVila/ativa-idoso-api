# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_presumed_incomes
#
#  id                       :bigint           not null, primary key
#  numero_plugin            :string
#  valor_da_renda_presumida :string
#  pro_score_report_id      :bigint           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
module ProScore
  class PresumedIncome < ApplicationRecord
    belongs_to :report, class_name: 'ProScore::Report',
                        foreign_key: 'pro_score_report_id',
                        inverse_of: :presumed_income

    validates :pro_score_report_id, uniqueness: true
  end
end
