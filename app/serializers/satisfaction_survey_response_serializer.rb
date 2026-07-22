# frozen_string_literal: true

require_relative 'application_serializer'

class SatisfactionSurveyResponseSerializer < ApplicationSerializer
  attributes :id,
             :user_id,
             :platform_access_score,
             :qr_code_access_score,
             :videos_understanding_score,
             :videos_motivation_score,
             :submitted_at
end
