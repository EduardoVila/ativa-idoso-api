# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_family_holdings
#
#  id                  :bigint           not null, primary key
#  numero_plugin       :string
#  cpf_do_parente      :string
#  nome_do_parente     :string
#  grau_de_parentesco  :string
#  pro_score_report_id :bigint
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
module ProScore
  class FamilyHolding < ApplicationRecord
    belongs_to :report, class_name: 'ProScore::Report',
                        foreign_key: 'pro_score_report_id',
                        inverse_of: :family_holdings
  end
end
