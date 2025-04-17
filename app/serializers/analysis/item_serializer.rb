# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_items
#
#  id                    :bigint           not null, primary key
#  cpf                   :string
#  disapproval_situation :integer
#  error_status          :integer          default("none")
#  features              :jsonb            not null
#  name                  :string
#  status                :integer          default("todo")
#  steps_data            :jsonb            not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  analysis_report_id    :bigint           not null
#  clone_of_id           :bigint
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
    attributes :id, :cpf, :name, :disapproval_situation, :debits, :age,
               :status, :created_at, :fee, :error_status, :approved,
               :presumed_incomes, :proprable_profession, :bounced_check,
               :protested_titles, :pro_score_bounced_checks, :clone_of_id,
               :provenir_big_data_corp, :steps_data, :predictions,
               :original_analysis_item

    def original_analysis_item
      return if object.clone_of_id.blank?

      object.clone_of.serialize_record(with: self.class)
    end

    def predictions
      object_with_associations.predictions.map(&:serialize_record)
    end

    def pro_score_bounced_checks
      return unless object_with_associations.pro_score_bounced_checks

      object_with_associations.pro_score_bounced_checks.map(&:serialize_record)
    end

    def provenir_big_data_corp
      return unless object_with_associations.provenir_big_data_corp.present?

      object_with_associations.provenir_big_data_corp.serialize_record
    end

    def presumed_incomes
      return unless object_with_associations.provenir_big_data_corp.present?

      financial_datum = object_with_associations.provenir_big_data_corp
        .financial_datum

      financial_datum&.income_estimate&.serialize_record
    end

    def proprable_profession
      object_with_associations.pro_score_proprable_profession&.serialize_record
    end

    def bounced_check
      object_with_associations.pro_score_bounced_check? || false
    end

    def name
      object_with_associations.boa_vista_cadastral_name
    end

    def age
      object_with_associations.boa_vista_cadastral_age
    end

    def approved
      predictions = object_with_associations.predictions

      return nil if predictions.blank?
      return human_analyzed.approved if human_analyzed.present?

      predictions.last.approved
    end

    def fee
      predictions = object_with_associations.predictions

      return nil if predictions.blank? || !approved

      prediction = human_analyzed.presence || predictions.last

      return 12.0 if prediction.fee.to_s.eql?('9.5')

      prediction.fee
    end

    def protested_titles
      boa_vista_acerta_essencial ||= object_with_associations
        .boa_vista_acerta_essencial

      return unless boa_vista_acerta_essencial.present?

      boa_vista_acerta_essencial.protested_titles.map(&:serialize_record)
    end

    def debits
      boa_vista_acerta_essencial ||= object_with_associations
        .boa_vista_acerta_essencial

      if boa_vista_acerta_essencial.present?
        return boa_vista_acerta_essencial.debits.map(&:serialize_record)
      end

      negative_data&.debits&.map(&:serialize_record)
    end

    private

    def object_with_associations
      object.clone_of || object
    end

    def serasa_fintech_report
      @serasa_fintech_report ||= object_with_associations.serasa_fintech_report
    end

    def negative_data
      @negative_data ||= serasa_fintech_report&.negative_data
    end

    def human_analyzed
      object_with_associations.predictions&.find do |prediction|
        prediction.label == 'human_analyzed'
      end
    end
  end
end
