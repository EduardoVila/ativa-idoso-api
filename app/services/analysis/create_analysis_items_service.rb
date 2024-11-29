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
        formatted_cpf = CPF::Formatter.format(cpf)
        previous_analysis_item = find_previous_analysis_item(formatted_cpf)

        if previous_analysis_item.present?
          clone_analysis_item(previous_analysis_item)

          next
        end

        analysis_report.items.create(cpf: formatted_cpf)
      end
    end

    private

    def clone_analysis_item(previous_analysis_item)
      new_analysis_item = previous_analysis_item.dup

      new_analysis_item.update(
        clone_of: previous_analysis_item,
        report: analysis_report,
        status: :todo
      )
    end

    def find_previous_analysis_item(formatted_cpf)
      Analysis::Item.where(status: :done, clone_of_id: nil).where(
        'cpf = :cpf AND analysis_items.created_at >= :date',
        cpf: formatted_cpf,
        date: Time.zone.today - 30.days
      ).last
    end
  end
end
