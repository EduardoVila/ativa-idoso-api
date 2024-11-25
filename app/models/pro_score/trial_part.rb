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
module ProScore
  class TrialPart < ApplicationRecord
    belongs_to :trial, class_name: 'ProScore::Trial',
                       foreign_key: 'pro_score_trial_id',
                       inverse_of: :parts
  end
end
