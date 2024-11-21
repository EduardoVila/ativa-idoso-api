# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_presumed_incomes
#
#  id                       :uuid             not null, primary key
#  numero_plugin            :string
#  valor_da_renda_presumida :string
#  pro_score_report_id      :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
FactoryBot.define do
  factory :pro_score_presumed_income, class: 'ProScore::PresumedIncome' do
    numero_plugin { '411' }
    valor_da_renda_presumida { '2.254,71' }

    report factory: :pro_score_report
  end
end
