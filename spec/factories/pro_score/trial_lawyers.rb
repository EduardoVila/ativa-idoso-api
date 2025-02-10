# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_lawyers
#
#  id                       :bigint           not null, primary key
#  advogado_nome            :string
#  cnpj                     :string
#  cpf                      :string
#  numero_do_processo_unico :string
#  numero_plugin            :string
#  oab_numero               :string
#  oab_uf                   :string
#  parte_nome               :string
#  tipo                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pro_score_trial_id       :bigint           not null
#
# Indexes
#
#  index_pro_score_trial_lawyers_on_pro_score_trial_id  (pro_score_trial_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_trial_id => pro_score_trials.id)
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
