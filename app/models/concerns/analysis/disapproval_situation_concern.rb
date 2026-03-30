# frozen_string_literal: true

module Analysis
  module DisapprovalSituationConcern
    extend ActiveSupport::Concern

    included do
      enum :disapproval_situation, %i[
        debtor
        blocked_negativity
        reproved_by_trial
        insufficient_income
        exceeded_debits
        blocked_cpf
        reproved_by_relative
        reproved_by_bounced_check
        reproved_by_age_and_income
        reproved_by_obit_indication
        reproved_by_protested_title
        reproved_by_recent_debit
        prediction
        reproved_by_minimum_age
      ]
    end
  end
end
