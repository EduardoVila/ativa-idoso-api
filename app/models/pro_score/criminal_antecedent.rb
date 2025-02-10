# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_criminal_antecedents
#
#  id                  :bigint           not null, primary key
#  certidao            :string
#  data_da_emissao     :string
#  hora_da_emissao     :string
#  numero_da_certidao  :string
#  numero_plugin       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  pro_score_report_id :bigint           not null
#
# Indexes
#
#  index_pro_score_criminal_antecedents_on_pro_score_report_id  (pro_score_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
#
module ProScore
  class CriminalAntecedent < ApplicationRecord
    belongs_to :report, class_name: 'ProScore::Report',
                        foreign_key: 'pro_score_report_id',
                        inverse_of: :criminal_antecedents
  end
end
