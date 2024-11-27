# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_lawyers
#
#  id                       :bigint           not null, primary key
#  numero_plugin            :string
#  numero_do_processo_unico :string
#  advogado_nome            :string
#  parte_nome               :string
#  cpf                      :string
#  cnpj                     :string
#  tipo                     :string
#  oab_numero               :string
#  oab_uf                   :string
#  pro_score_trial_id       :bigint           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
module ProScore
  class TrialLawyer < ApplicationRecord
    belongs_to :trial, class_name: 'ProScore::Trial',
                       foreign_key: 'pro_score_trial_id',
                       inverse_of: :lawyers
  end
end
