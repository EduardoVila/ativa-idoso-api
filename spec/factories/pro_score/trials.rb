# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trials
#
#  id                       :bigint           not null, primary key
#  area                     :string
#  causa_moeda              :string
#  causa_valor              :string
#  classe_processual_nome   :string
#  data_distribuicao        :datetime
#  data_processamento       :datetime
#  juiz                     :string
#  numero_do_processo_unico :string
#  numero_plugin            :string
#  orgao_julgador           :string
#  segmento                 :string
#  sistema                  :string
#  tribunal                 :string
#  uf                       :string
#  unidade_origem           :string
#  url_processo             :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pro_score_report_id      :bigint           not null
#
# Indexes
#
#  index_pro_score_trials_on_pro_score_report_id  (pro_score_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
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
