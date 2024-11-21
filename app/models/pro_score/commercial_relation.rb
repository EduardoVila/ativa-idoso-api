# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_commercial_relations
#
#  id                  :uuid             not null, primary key
#  numero_plugin       :string
#  cpfcnpj             :string
#  razao_social        :string
#  pro_score_report_id :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
module ProScore
  class CommercialRelation < ApplicationRecord
    belongs_to :report, class_name: 'ProScore::Report',
                        foreign_key: 'pro_score_report_id',
                        inverse_of: :commercial_relations
  end
end
