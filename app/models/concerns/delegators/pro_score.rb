# frozen_string_literal: true

module Delegators
  module ProScore
    extend ActiveSupport::Concern

    included do
      delegate :trials_approved?, :presumed_income_value, :commercial_relations,
               :trials, :bounced_checks, :presumed_income, :family_holdings,
               :company, :bounced_check?, :proprable_profession,
               to: :pro_score_report, allow_nil: true, prefix: :pro_score
    end
  end
end
