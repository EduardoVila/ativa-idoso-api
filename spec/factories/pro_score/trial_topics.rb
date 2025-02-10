# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_topics
#
#  id                       :bigint           not null, primary key
#  codigo_cnpj              :string
#  numero_do_processo_unico :string
#  numero_plugin            :string
#  titulo                   :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pro_score_trial_id       :bigint           not null
#
# Indexes
#
#  index_pro_score_trial_topics_on_pro_score_trial_id  (pro_score_trial_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_trial_id => pro_score_trials.id)
#
FactoryBot.define do
  factory :pro_score_trial_topic, class: 'ProScore::TrialTopic' do
    numero_plugin { '5194' }
    numero_do_processo_unico { SecureRandom.hex }
    codigo_cnpj { CNPJ.generate }
    titulo { Faker::Lorem.word }

    trait :with_disapproved_title do
      titulo { 'locacao' }
    end

    trial factory: :pro_score_trial
  end
end
