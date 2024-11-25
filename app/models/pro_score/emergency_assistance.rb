# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_emergency_assistances
#
#  id                  :bigint           not null, primary key
#  numero_plugin       :string
#  mes_disponibilizado :string
#  codigo_do_municipio :string
#  municipio           :string
#  uf                  :string
#  parcelas            :string
#  valor               :string
#  enquadramento       :string
#  observacao          :string
#  pro_score_report_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
module ProScore
  class EmergencyAssistance < ApplicationRecord
    belongs_to :report, class_name: 'ProScore::Report',
                        foreign_key: 'pro_score_report_id',
                        inverse_of: :emergency_assistances
  end
end
