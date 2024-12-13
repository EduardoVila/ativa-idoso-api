# frozen_string_literal: true

module Validators
  module FinancialValidatable
    attr_reader :analysis_item

    def blocked_negativity_validator
      unless analysis_item.boa_vista_acerta_essencial_debit_approved?
        return financial_result(false, :blocked_negativity)
      end

      financial_result(true, nil)
    end

    def exceeded_debits_validator
      if boa_vista_debits.count > 3
        return financial_result(false, :exceeded_debits)
      end

      financial_result(true, nil)
    end

    def reproved_by_recent_debit_validator
      current_semester_debits = boa_vista_debits&.current_semester || []

      if current_semester_debits.any? { |debit| debit.value.to_i >= 100 }
        return financial_result(false, :reproved_by_recent_debit)
      end

      financial_result(true, nil)
    end

    def protested_titles_validator
      unless analysis_item.boa_vista_acerta_essencial_protested_titles.empty?
        return financial_result(false, :reproved_by_protested_title)
      end

      financial_result(true, nil)
    end

    def age_and_income_validator
      age = analysis_item.boa_vista_cadastral_age

      return financial_result(true, nil) if age.blank? || age > 25

      presumed_income = analysis_item.pro_score_presumed_income_value

      if boa_vista_debits.present? || presumed_income.to_i < 1200
        return financial_result(false, :reproved_by_age_and_income)
      end

      financial_result(true, nil)
    end

    private

    def financial_result(approved, disapproval_situation)
      { status: 'success', approved:, disapproval_situation: }
    end

    def boa_vista_debits
      analysis_item.boa_vista_acerta_essencial_debits
    end
  end
end
