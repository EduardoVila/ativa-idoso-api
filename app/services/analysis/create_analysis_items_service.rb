# frozen_string_literal: true

require_relative '../application_service'

module Analysis
  class CreateAnalysisItemsService < ApplicationService
    attr_reader :analysis_report, :cpfs

    def initialize(analysis_report)
      @analysis_report = analysis_report
      @cpfs = analysis_report.cpfs
    end

    def call
      return if analysis_report.items.any?

      cpfs.each do |cpf|
        previous_analysis_item = find_previous_analysis_item(cpf)

        if previous_analysis_item.present?
          clone_analysis_item(previous_analysis_item)

          next
        end

        create_analysis_item(cpf)
      end
    end

    private

    def clone_analysis_item(previous_analysis_item)
      new_analysis_item = previous_analysis_item.dup

      new_analysis_item.update(
        clone_of: previous_analysis_item,
        report: analysis_report,
        status: :done,
        features: previous_analysis_item.features,
        disapproval_situation: previous_analysis_item.disapproval_situation
      )

      previous_analysis_item.predictions.each do |prediction|
        new_prediction = prediction.dup

        new_prediction.update(analysis_item: new_analysis_item)
      end
    end

    def find_previous_analysis_item(cpf)
      Analysis::Item.where(status: :done, clone_of_id: nil).where("
        cpf = :cpf AND analysis_items.created_at >= :date
      ", cpf: cpf, date: Time.zone.today - 30.days).last
    end

    def create_analysis_item(cpf)
      analysis_report.items.create(cpf: cpf, status: :todo)
    end
  end
end
