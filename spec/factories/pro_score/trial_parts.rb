# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_parts
#
#  id                       :bigint           not null, primary key
#  documento                :string
#  nome                     :string
#  numero_do_processo_unico :string
#  numero_plugin            :string
#  polo                     :string
#  tipo                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pro_score_trial_id       :bigint           not null
#
# Indexes
#
#  index_pro_score_trial_parts_on_pro_score_trial_id  (pro_score_trial_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_trial_id => pro_score_trials.id)
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
