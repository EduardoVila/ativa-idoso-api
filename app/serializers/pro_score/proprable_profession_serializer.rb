# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_proprable_professions
#
#  id                  :bigint           not null, primary key
#  numero_plugin       :string
#  codigo              :string
#  titulo              :string
#  pro_score_report_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require_relative '../application_serializer'

module ProScore
  class ProprableProfessionSerializer < ApplicationSerializer
    attributes :id, :numero_plugin, :codigo, :titulo
  end
end
