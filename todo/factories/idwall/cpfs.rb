# frozen_string_literal: true

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

    idwall_report
  end
end
