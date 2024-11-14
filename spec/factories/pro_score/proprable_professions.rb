# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_proprable_professions
#
#  id                  :bigint           not null, primary key
#  numero_plugin       :string
#  codigo              :string
#  titulo              :string
#  pro_score_report_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :pro_score_proprable_profession,
          class: 'ProScore::ProprableProfession' do
    numero_plugin { '404' }
    codigo { '514' }
    titulo { 'TRABALHADORES NOS SERVICOS DE ADMINISTRACAO' }

    report factory: :pro_score_report
  end
end
