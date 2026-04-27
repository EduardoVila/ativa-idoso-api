# frozen_string_literal: true

module ResearchAndDevelopment
  class PopulateAnalysisItemJob
    include Sidekiq::Job

    queue_as :default

    def perform(analysis_item)
      ResearchAndDevelopment::PopulateAnalysisItemService.call(analysis_item)
    end
  end
end
