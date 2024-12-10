# frozen_string_literal: true

module PreValidationsHelper
  def sample_validator_and_disapproval
    validators = {
      'blocked_negativity_validator' => [:reproved_by_blocked_negativity],
      'exceeded_debits_validator' => [:reproved_by_exceeded_debits],
      'reproved_by_recent_debit_validator' => [:reproved_by_recent_debit],
      'protested_titles_validator' => [:reproved_by_protested_title],
      # 'age_and_income_validator' => [:reproved_by_age_and_income], not enabled, using provenir data
      'provenir_has_obit_indication_validator' => [
        :reproved_by_obit_indication
      ],
      'provenir_family_holding_validator' => [:reproved_by_relative],
      'provenir_process_validator' => [:reproved_by_trial],
      'provenir_age_and_income_validator' => [:reproved_by_age_and_income]
    }

    validator = validators.keys.sample
    disapproval_situation = validators[validator].sample

    {
      validator:,
      reproved_hash_data: {
        status: 'success',
        approved: false,
        disapproval_situation:
      }
    }
  end
end
