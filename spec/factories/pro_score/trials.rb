# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trials
#
#  id                       :bigint           not null, primary key
#  numero_plugin            :string
#  numero_do_processo_unico :string
#  data_distribuicao        :datetime
#  area                     :string
#  causa_moeda              :string
#  causa_valor              :string
#  unidade_origem           :string
#  url_processo             :string
#  sistema                  :string
#  data_processamento       :datetime
#  tribunal                 :string
#  uf                       :string
#  segmento                 :string
#  classe_processual_nome   :string
#  orgao_julgador           :string
#  juiz                     :string
#  pro_score_report_id      :bigint           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
FactoryBot.define do
  factory :pro_score_trial, class: 'ProScore::Trial' do
    numero_plugin { '466 ' }
    numero_do_processo_unico { SecureRandom.hex }
    area { 'JUIZADO ESPECIAL CIVEL' }
    causa_moeda { 'R$' }
    causa_valor { rand(1000..9000) }
    unidade_origem { Faker::Address.city }
    url_processo { 'https://projudi.tjpr.jus.br/projudi/' }
    sistema { 'PROJUDI-TJPR' }
    data_processamento { Time.zone.today }
    tribunal { 'TJ-PR' }
    uf { Faker::Address.state_abbr }
    segmento { 'JUSTICA ESTADUAL' }
    data_distribuicao { Time.zone.today }
    classe_processual_nome { 'EXECUCAO DE TITULO EXTRAJUDICIAL' }
    orgao_julgador { '1 JUIZADO ESPECIAL CIVEL DE PONTA GROSSA' }
    juiz { Faker::Name.name }

    trait :with_disapproved_area do
      area { 'CRIMINAL' }
    end

    trait :with_disapproved_classe_processual_nome do
      classe_processual_nome { 'PROCEDIMENTO ESPECIAL DA LEI DE DROGAS' }
    end

    report factory: :pro_score_report
  end
end
