# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_family_holdings
#
#  id                  :bigint           not null, primary key
#  cpf_do_parente      :string
#  grau_de_parentesco  :string
#  nome_do_parente     :string
#  numero_plugin       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  pro_score_report_id :bigint           not null
#
# Indexes
#
#  index_pro_score_family_holdings_on_pro_score_report_id  (pro_score_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
#
module ProScore
  class FamilyHolding < ApplicationRecord
    belongs_to :report, class_name: 'ProScore::Report',
                        foreign_key: 'pro_score_report_id',
                        inverse_of: :family_holdings
  end
end
