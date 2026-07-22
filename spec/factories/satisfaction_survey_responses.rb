FactoryBot.define do
  factory :satisfaction_survey_response do
    user
    platform_access_score { 5 }
    qr_code_access_score { 5 }
    videos_understanding_score { 4 }
    videos_motivation_score { 4 }
  end
end
