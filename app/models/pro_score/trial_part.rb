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
module ProScore
  class TrialPart < ApplicationRecord
    belongs_to :trial, class_name: 'ProScore::Trial',
                       foreign_key: 'pro_score_trial_id',
                       inverse_of: :parts
  end
end
