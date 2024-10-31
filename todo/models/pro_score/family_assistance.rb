# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_family_assistances
#
#  id                       :bigint           not null, primary key
#  numero_plugin            :string
#  valor                    :string
#  ultima_data_do_beneficio :string
#  consta_beneficio         :string
#  pro_score_report_id      :bigint
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
module ProScore
  class FamilyAssistance < ApplicationRecord
    belongs_to :report, class_name: 'ProScore::Report',
                        foreign_key: 'pro_score_report_id',
                        inverse_of: :family_assistance
  end
end
