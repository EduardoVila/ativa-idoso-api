# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_cpfs
#
#  id                      :bigint           not null, primary key
#  birth_date              :string
#  cpf_cadastral_situation :string
#  cpf_subscription_date   :string
#  cpf_verifying_digit     :string
#  gender                  :string
#  income                  :string
#  income_tax_situation    :string
#  name                    :string
#  number                  :string
#  social_name             :string
#  source                  :string
#  year_of_death           :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  idwall_report_id        :bigint           not null
#
# Indexes
#
#  index_idwall_cpfs_on_idwall_report_id  (idwall_report_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (idwall_report_id => idwall_reports.id)
#
FactoryBot.define do
  factory :idwall_cpf, class: 'Idwall::CPF' do
    gender { 'M' }
    number { Faker::CPF.pretty }
    birth_date { '13/02/1969' }
    source { 'RECEITA FEDERAL' }
    name { Faker::Name.name }
    income { '3 - 4 A 10 SM' }
    income_tax_situation { 'REGULAR' }
    cpf_cadastral_situation { 'REGULAR' }
    cpf_subscription_date { 'anterior a 10/11/1990' }
    cpf_verifying_digit { '00' }
    year_of_death { '' }
    social_name { '' }

    idwall_report factory: :idwall_report
  end
end
