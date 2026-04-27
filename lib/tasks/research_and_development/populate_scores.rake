# frozen_string_literal: true

namespace :populate_scores do
  desc 'Populates de R&D analysis item table'

  task run: :environment do
    AnalysisItem.find_each do |analysis_item|
      next if ResearchAndDevelopment::AnalysisItem.exists?(
        analysis_items_cpf: analysis_item.cpf,
        analysis_items_analysis_report_id: analysis_item.analysis_report_id
      )

      ResearchAndDevelopment::PopulateScoreJob.perform_async(analysis_item)
    end
  end
end
