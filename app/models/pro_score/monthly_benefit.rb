# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_monthly_benefits
#
#  id                                :bigint           not null, primary key
#  numero_plugin                     :string
#  mes_competencia                   :string
#  mes_referencia                    :string
#  uf                                :string
#  nome_municipio                    :string
#  nis_beneficiario                  :string
#  numero_beneficio                  :string
#  beneficio_concedido_judicialmente :string
#  valor_parcela                     :string
#  pro_score_report_id               :bigint           not null
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#
module ProScore
  class MonthlyBenefit < ApplicationRecord
    belongs_to :report, class_name: 'ProScore::Report',
                        foreign_key: 'pro_score_report_id',
                        inverse_of: :monthly_benefits
  end
end
