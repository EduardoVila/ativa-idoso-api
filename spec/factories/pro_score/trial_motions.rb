# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_motions
#
#  id                       :bigint           not null, primary key
#  data                     :datetime
#  nome_original            :string
#  numero_do_processo_unico :string
#  numero_plugin            :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pro_score_trial_id       :bigint           not null
#
# Indexes
#
#  index_pro_score_trial_motions_on_pro_score_trial_id  (pro_score_trial_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_trial_id => pro_score_trials.id)
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
