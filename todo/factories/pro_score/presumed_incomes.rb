# frozen_string_literal: true

FactoryBot.define do
  factory :pro_score_presumed_income, class: 'ProScore::PresumedIncome' do
    numero_plugin { '411' }
    valor_da_renda_presumida { '2.254,71' }

    report { create :pro_score_report }
  end
end
