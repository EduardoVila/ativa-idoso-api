# frozen_string_literal: true

module ResearchAndDevelopment
  class AnalysisItem < ApplicationRecord
    enum :analysis_items_payment_situation, {
      unanalyzed: 0, good_payer: 1, no_payer: 2, new_client: 3, late_payer: 4
    }, suffix: true

    enum :analysis_items_status, {
      todo: 0, wip: 1, done: 2, not_found: 3, error: 4
    }

    enum :analysis_items_error_status, {
      none: 0,
      idwall: 1,
      boa_vista: 2,
      pro_score_trials: 3,
      serasa: 4,
      pro_score_family_holdings: 5,
      pro_score_bounced_checks: 6,
      pro_score_presumed_income: 7,
      pro_score_commercial_relations: 8,
      provenir_big_data_corp: 9
    }, suffix: true

    enum :analysis_item_disapproval_situation, {
      debtor: 1,
      blocked_negativity: 2,
      reproved_by_trial: 3,
      insufficient_income: 4,
      exceeded_debits: 5,
      blocked_cpf: 6,
      reproved_by_relative: 7,
      reproved_by_bounced_check: 8,
      reproved_by_age_and_income: 9,
      reproved_by_obit_indication: 10,
      reproved_by_protested_title: 11,
      reproved_by_recent_debit: 12,
      prediction: 13
    }

    enum :bv_acerta_essencials_credit_type, {
      CC: 0, CD: 1, CG: 2, CH: 3, CP: 4, CV: 5, OU: 6
    }

    enum :idwall_reports_status, { processing: 0, processed: 1 }
  end
end
