# frozen_string_literal: true

FactoryBot.define do
  factory :idwall_trial, class: 'Idwall::Trial' do
    subject { 'Locação de Imóvel' }
    kind { 'Despejo por Falta de Pagamento Cumulado Com Cobrança' }

    idwall_report
  end
end
