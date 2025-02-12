# frozen_string_literal: true

# AnalysisReportSyncCommand provides a way to sync the analysis report with its items
# it's important to change the analysis report status and send payload through API requests

require_relative '../application_command'
require_relative '../concerns/payload_sender'

module Analysis
  class ReportSyncCommand < ApplicationCommand
    attr_reader :analysis_report

    def initialize(analysis_report)
      super()
      @analysis_report = analysis_report
    end

    def call
      return if %w[done not_found].include?(analysis_report.status) ||
                %w[wip todo].include?(sync_status)

      generate_result
      send_payload
    end

    private

    def sync_status
      analysis_report.status = :done

      analysis_report.items.each do |analysis_item|
        if analysis_item.todo?
          analysis_report.status = :wip

          break
        end

        unless analysis_item.status == 'done'
          analysis_report.status = analysis_item.status
        end

        status_breakers = %w[error not_found]

        break if status_breakers.include?(analysis_report.status)
      end

      analysis_report.save

      analysis_report.status
    end

    def approved?
      analysis_report.items&.joins(:predictions).present?
    end

    def generate_result
      analysis_items = analysis_report.items
      analysis_report.approved = approved?

      return if analysis_items.blank?

      check_reprovement(analysis_items)

      return unless analysis_report.approved? # if not approved, no need to calculate fee

      # calculate fee based on the last prediction
      analysis_items.each do |analysis_item|
        predictions = analysis_item.predictions
        prediction = human_analyzed(analysis_item) || predictions.last

        next if prediction.blank?

        unless prediction.approved
          analysis_report.update(approved: false, fee: nil)

          break
        end

        analysis_report.calculate_fee(prediction)
      end
    end

    def human_analyzed(analysis_item)
      analysis_item.predictions.find_by(label: 'human_analyzed')
    end

    def send_payload
      payload = analysis_report.payload

      return if payload.blank?

      PayloadSender.send(payload, analysis_report.serialize_record)
    end

    def check_reprovement(analysis_items)
      disapproval_situations = analysis_items.pluck(:disapproval_situation)
      ordered_situations = reproval_situations & disapproval_situations

      return if ordered_situations.blank?

      reprove_analysis_report(ordered_situations)
    end

    def reprove_analysis_report(disapproval_situation)
      analysis_report.update(
        status: :done,
        disapproval_situation: disapproval_situation.first
      )
    end

    def reproval_situations
      %w[
        blocked_cpf
        reproved_by_trial
        blocked_negativity
        debtor
        insufficient_income
        exceeded_debits
        reproved_by_relative
        reproved_by_bounced_check
        reproved_by_age_and_income
        prediction
      ]
    end
  end
end
