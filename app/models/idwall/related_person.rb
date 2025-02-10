# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_related_people
#
#  id               :bigint           not null, primary key
#  cpf              :string
#  kind             :string
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  idwall_report_id :bigint           not null
#
# Indexes
#
#  index_idwall_related_people_on_idwall_report_id  (idwall_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (idwall_report_id => idwall_reports.id)
#
module Idwall
  class RelatedPerson < ApplicationRecord
    belongs_to :idwall_report, class_name: 'Idwall::Report'
  end
end
