# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_motions
#
#  id                       :bigint           not null, primary key
#  numero_plugin            :string
#  numero_do_processo_unico :string
#  data                     :datetime
#  nome_original            :string
#  pro_score_trial_id       :bigint           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
FactoryBot.define do
  factory :pro_score_trial_motion, class: 'ProScore::TrialMotion' do
    numero_plugin { '467' }
    numero_do_processo_unico { SecureRandom.hex }
    data { Faker::Date.between(from: 2.years.ago, to: Time.zone.today) }
    nome_original { Faker::Name.name }

    trial factory: :pro_score_trial
  end
end
