# frozen_string_literal: true

namespace :populate_scores do
  desc 'Populates de R&D analysis item table'

  task run: :environment do
    Analysis::Item.find_each do |analysis_item|
      next if ResearchAndDevelopment::AnalysisItem.exists?(
        analysis_items_cpf: analysis_item.cpf,
        analysis_items_analysis_report_id: analysis_item.analysis_report_id
      )

      ResearchAndDevelopment::PopulateAnalysisItemJob.perform_async(
        analysis_item.id
      )
    end
  end
end
