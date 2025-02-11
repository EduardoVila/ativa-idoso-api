# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_items
#
#  id                    :uuid             not null, primary key
#  cpf                   :string
#  disapproval_situation :integer
#  error_status          :integer          default("none")
#  features              :jsonb
#  name                  :string
#  prediction            :integer
#  status                :integer          default("todo")
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  analysis_report_id    :uuid             not null
#  clone_of_id           :uuid
#
# Indexes
#
#  index_analysis_items_on_analysis_report_id  (analysis_report_id)
#  index_analysis_items_on_clone_of_id         (clone_of_id)
#
# Foreign Keys
#
#  fk_rails_...  (analysis_report_id => analysis_reports.id)
#  fk_rails_...  (clone_of_id => analysis_items.id)
#
require_relative '../application_serializer'

module Analysis
  class ItemSerializer < ApplicationSerializer
    attributes :id, :cpf, :name, :disapproval_situation, :debits,
               :status, :created_at, :prediction, :original,
               :error_status, :human_analyzed_prediction,
               :approved, :presumed_income_value, :proprable_profession,
               :bounced_check, :trials

    def original
      object.clone_of&.serialize_record
    end

    def presumed_income_value
      if object.pro_score_presumed_income_value
        return format('%.2f', object.pro_score_presumed_income_value)
      end

      object.provenir_bigdata_v2 || '0.00'
    end

    def proprable_profession
      object.pro_score_proprable_profession&.serialize_record
    end

    def bounced_check
      object.pro_score_bounced_check? || false
    end

    def trials
      provider_trials&.map(&:serialize_record)
    end

    def name
      object.boa_vista_cadastral_name
    end

    def age
      object.boa_vista_cadastral_age
    end

    def human_analyzed_prediction
      human_analyzed&.serialize_record
    end

    def approved
      predictions = object.predictions

      return nil if predictions.blank?
      return human_analyzed.approved if human_analyzed.present?

      predictions.last.approved
    end

    def prediction
      predictions = object.predictions

      return nil if predictions.blank? || !approved

      prediction = human_analyzed.presence || predictions.last

      return 12.0 if prediction.fee.to_s.eql?('9.5')

      prediction.fee
    end

    def debits
      if boa_vista_acerta_essencial.present?
        return @boa_vista_acerta_essencial.debits.map(&:serialize_record)
      end

      negative_data&.debits&.map(&:serialize_record)
    end

    private

    def boa_vista_acerta_essencial
      @boa_vista_acerta_essencial ||= object.boa_vista_acerta_essencial
    end

    def provider_trials
      object.pro_score_trials || object.provenir_lawsuits
    end

    def serasa_fintech_report
      @serasa_fintech_report ||= object.serasa_fintech_report
    end

    def negative_data
      @negative_data ||= serasa_fintech_report&.negative_data
    end

    def human_analyzed
      object.predictions.find_by(label: 'human_analyzed')
    end
  end
end
