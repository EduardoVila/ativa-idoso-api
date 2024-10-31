# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_lawyers
#
#  id                       :bigint           not null, primary key
#  advogado_nome            :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pro_score_trial_id       :bigint
#  numero_plugin            :string
#  numero_do_processo_unico :string
#  parte_nome               :string
#  cpf                      :string
#  cnpj                     :string
#  tipo                     :string
#  oab_numero               :string
#  oab_uf                   :string
#
module ProScore
  class TrialLawyer < ApplicationRecord
    belongs_to :trial, class_name: 'ProScore::Trial',
                       foreign_key: 'pro_score_trial_id',
                       inverse_of: :lawyers
  end
end
