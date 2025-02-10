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
module ProScore
  class TrialTopic < ApplicationRecord
    belongs_to :trial, class_name: 'ProScore::Trial',
                       foreign_key: 'pro_score_trial_id',
                       inverse_of: :topics
  end
end
