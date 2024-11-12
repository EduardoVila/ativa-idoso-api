# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_topics
#
#  id                       :uuid             not null, primary key
#  numero_plugin            :string
#  numero_do_processo_unico :string
#  codigo_cnpj              :string
#  titulo                   :string
#  pro_score_trial_id       :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
module ProScore
  class TrialTopic < ApplicationRecord
    belongs_to :trial, class_name: 'ProScore::Trial',
                       foreign_key: 'pro_score_trial_id',
                       inverse_of: :topics
  end
end
