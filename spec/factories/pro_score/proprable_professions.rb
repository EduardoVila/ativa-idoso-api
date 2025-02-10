# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_proprable_professions
#
#  id                  :bigint           not null, primary key
#  codigo              :string
#  numero_plugin       :string
#  titulo              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  pro_score_report_id :bigint           not null
#
# Indexes
#
#  index_pro_score_proprable_professions_on_pro_score_report_id  (pro_score_report_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
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
