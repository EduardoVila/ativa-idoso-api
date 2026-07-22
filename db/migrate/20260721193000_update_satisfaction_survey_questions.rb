# frozen_string_literal: true

class UpdateSatisfactionSurveyQuestions < ActiveRecord::Migration[7.2]
  def up
    rename_column :satisfaction_survey_responses,
                  :exercise_guidance_score,
                  :videos_understanding_score
    rename_column :satisfaction_survey_responses,
                  :daily_activities_score,
                  :videos_motivation_score

    add_column :satisfaction_survey_responses,
               :platform_access_score,
               :integer,
               default: 3,
               null: false
  end

  def down
    remove_column :satisfaction_survey_responses, :platform_access_score
    rename_column :satisfaction_survey_responses,
                  :videos_motivation_score,
                  :daily_activities_score
    rename_column :satisfaction_survey_responses,
                  :videos_understanding_score,
                  :exercise_guidance_score
  end
end
