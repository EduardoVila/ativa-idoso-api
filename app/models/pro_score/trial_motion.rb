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
module ProScore
  class TrialMotion < ApplicationRecord
    belongs_to :trial, class_name: 'ProScore::Trial',
                       foreign_key: 'pro_score_trial_id',
                       inverse_of: :motions
  end
end
