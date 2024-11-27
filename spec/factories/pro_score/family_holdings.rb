# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_family_holdings
#
#  id                  :bigint           not null, primary key
#  numero_plugin       :string
#  cpf_do_parente      :string
#  nome_do_parente     :string
#  grau_de_parentesco  :string
#  pro_score_report_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :pro_score_family_holding, class: 'ProScore::FamilyHolding' do
    numero_plugin { '454' }
    cpf_do_parente { Faker::CPF.pretty }
    nome_do_parente { Faker::Name.name }
    grau_de_parentesco { 'IRMAO' }

    report factory: :pro_score_report
  end
end
