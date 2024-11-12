# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_lawyers
#
#  id                       :uuid             not null, primary key
#  numero_plugin            :string
#  numero_do_processo_unico :string
#  advogado_nome            :string
#  parte_nome               :string
#  cpf                      :string
#  cnpj                     :string
#  tipo                     :string
#  oab_numero               :string
#  oab_uf                   :string
#  pro_score_trial_id       :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
FactoryBot.define do
  factory :pro_score_trial_lawyer, class: 'ProScore::TrialLawyer' do
    numero_plugin { '468' }
    numero_do_processo_unico { SecureRandom.hex }
    parte_nome { Faker::Company.name }
    advogado_nome { Faker::Name.name }
    cpf { Faker::CPF.pretty }
    cnpj { CNPJ.generate }
    tipo { 'ADVOGADO' }
    oab_numero { rand(10_000..99_999) }
    oab_uf { Faker::Address.state_abbr }

    trial factory: :pro_score_trial
  end
end
