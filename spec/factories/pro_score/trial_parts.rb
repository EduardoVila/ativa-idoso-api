# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_parts
#
#  id                       :bigint           not null, primary key
#  numero_plugin            :string
#  numero_do_processo_unico :string
#  nome                     :string
#  documento                :string
#  tipo                     :string
#  polo                     :string
#  pro_score_trial_id       :bigint           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
FactoryBot.define do
  factory :pro_score_trial_part, class: 'ProScore::TrialPart' do
    nome { Faker::Name.name }
    numero_plugin { '467 ' }
    numero_do_processo_unico { SecureRandom.hex }
    documento { Faker::CPF.pretty }

    trait :defendant do
      tipo { 'EXECUTADO' }
      polo { 'PASSIVO' }
    end

    trait :plaintiff do
      tipo { 'EXEQUENTE' }
      polo { 'ATIVO' }
    end

    trial factory: :pro_score_trial

    # default traits
    defendant
  end
end
