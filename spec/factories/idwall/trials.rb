# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_trials
#
#  id               :bigint           not null, primary key
#  kind             :string
#  subject          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  idwall_report_id :bigint           not null
#
# Indexes
#
#  index_idwall_trials_on_idwall_report_id  (idwall_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (idwall_report_id => idwall_reports.id)
#
FactoryBot.define do
  factory :idwall_trial, class: 'Idwall::Trial' do
    subject { 'Locação de Imóvel' }
    kind { 'Despejo por Falta de Pagamento Cumulado Com Cobrança' }

    idwall_report factory: :idwall_report
  end
end
