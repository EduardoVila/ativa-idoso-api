# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_criminal_antecedents
#
#  id                  :uuid             not null, primary key
#  numero_plugin       :string
#  numero_da_certidao  :string
#  certidao            :string
#  data_da_emissao     :string
#  hora_da_emissao     :string
#  pro_score_report_id :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
module ProScore
  class CriminalAntecedent < ApplicationRecord
    belongs_to :report, class_name: 'ProScore::Report',
                        foreign_key: 'pro_score_report_id',
                        inverse_of: :criminal_antecedents
  end
end
