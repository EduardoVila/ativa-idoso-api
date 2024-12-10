# frozen_string_literal: true

module AnalysisModules
  module ProvenirValidators
    attr_reader :analysis_item

    EXCEPTION_RELATIONSHIPS = %w[
      COWORKER
      HOUSEHOLD
      NEIGHBOR
      COLLEGECLASS
    ].freeze

    LOW_INCOME = ['0 A 1 SM', 'SEM INFORMACAO'].freeze

    def provenir_has_obit_indication_validator
      valid = !analysis_item.provenir_has_obit_indication

      provenir_result(valid, :reproved_by_obit_indication)
    end

    def provenir_family_holding_validator
      valid = true

      personal_relationships = analysis_item.provenir_personal_relationships

      personal_relationships&.each do |personal_relationship|
        next if invalid_personal_relationship?(personal_relationship)

        formatted_cpf = CPF::Formatter.format(
          personal_relationship.related_entity_tax_id_number
        )

        next unless provenir_reproved_relative?(formatted_cpf)

        valid = false

        break
      end

      provenir_result(valid, :reproved_by_relative)
    end

    def provenir_process_validator
      valid = true

      analysis_item.provenir_lawsuits&.each do |lawsuit|
        next unless lawsuit.disapproved?

        valid = false

        break
      end

      provenir_result(valid, :reproved_by_trial)
    end

    def provenir_age_and_income_validator
      valid = true

      provenir_basic_datum = analysis_item.provenir_basic_datum

      unless provenir_basic_datum&.age&.>= 25
        provenir_income_estimate = analysis_item.provenir_income_estimate

        if LOW_INCOME.include?(provenir_income_estimate&.bigdata_v2)
          valid = false
        end
      end

      provenir_result(valid, :reproved_by_age_and_income)
    end

    private

    def provenir_result(approved, disapproval_situation)
      if approved
        return { status: 'success', approved:, disapproval_situation: nil }
      end

      { status: 'success', approved:, disapproval_situation: }
    end

    def provenir_reproved_relative?(cpf)
      date = Time.zone.today - 30.days

      Analysis::Item.joins(:predictions)
        .where(status: :done, cpf:)
        .where(
          'analysis_predictions.approved = false AND
          analysis_items.created_at >= :date', date:
        )
        .where.not(analysis_report_id: analysis_item.analysis_report_id)
        .exists?
    end

    def invalid_personal_relationship?(personal_relationship)
      return true if personal_relationship.related_entity_tax_id_type != 'CPF'

      relationship_type = personal_relationship.relationship_type

      EXCEPTION_RELATIONSHIPS.include?(relationship_type)
    end
  end
end
