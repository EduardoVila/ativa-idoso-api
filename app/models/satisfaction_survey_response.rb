# frozen_string_literal: true

class SatisfactionSurveyResponse < ApplicationRecord
  belongs_to :user

  SCORES = %i[
    platform_access_score
    qr_code_access_score
    videos_understanding_score
    videos_motivation_score
  ].freeze

  before_validation :set_submitted_at, on: :create

  validates :user_id, uniqueness: true
  validates(*SCORES, inclusion: { in: 1..5 })
  validates :submitted_at, presence: true

  private

  def set_submitted_at
    self.submitted_at ||= Time.current
  end
end
