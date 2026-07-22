class CreateSatisfactionSurveyResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :satisfaction_survey_responses do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.integer :qr_code_access_score, null: false
      t.integer :exercise_guidance_score, null: false
      t.integer :daily_activities_score, null: false
      t.datetime :submitted_at, null: false

      t.timestamps
    end
  end
end
