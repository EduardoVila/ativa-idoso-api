# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_related_people
#
#  id               :bigint           not null, primary key
#  cpf              :string
#  name             :string
#  kind             :string
#  idwall_report_id :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
module Idwall
  class RelatedPerson < ApplicationRecord
    belongs_to :idwall_report, class_name: 'Idwall::Report'
  end
end
