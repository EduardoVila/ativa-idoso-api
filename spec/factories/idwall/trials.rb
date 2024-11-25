# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_trials
#
#  id               :bigint           not null, primary key
#  subject          :string
#  kind             :string
#  idwall_report_id :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :idwall_trial, class: 'Idwall::Trial' do
    subject { 'Locação de Imóvel' }
    kind { 'Despejo por Falta de Pagamento Cumulado Com Cobrança' }

    idwall_report factory: :idwall_report
  end
end
