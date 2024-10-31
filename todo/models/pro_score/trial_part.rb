# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_parts
#
#  id                       :bigint           not null, primary key
#  nome                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pro_score_trial_id       :bigint
#  numero_plugin            :string
#  numero_do_processo_unico :string
#  documento                :string
#  tipo                     :string
#  polo                     :string
#
module ProScore
  class TrialPart < ApplicationRecord
    belongs_to :trial, class_name: 'ProScore::Trial',
                       foreign_key: 'pro_score_trial_id',
                       inverse_of: :parts
  end
end
