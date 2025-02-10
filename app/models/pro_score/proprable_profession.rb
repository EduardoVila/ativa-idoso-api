# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_proprable_professions
#
#  id                  :bigint           not null, primary key
#  codigo              :string
#  numero_plugin       :string
#  titulo              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  pro_score_report_id :bigint           not null
#
# Indexes
#
#  index_pro_score_proprable_professions_on_pro_score_report_id  (pro_score_report_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
#
module ProScore
  class ProprableProfession < ApplicationRecord
    belongs_to :report, class_name: 'ProScore::Report',
                        foreign_key: 'pro_score_report_id',
                        inverse_of: :proprable_profession

    validates :pro_score_report_id, uniqueness: true
  end
end
