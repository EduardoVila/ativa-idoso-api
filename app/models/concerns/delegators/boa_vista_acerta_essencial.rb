# frozen_string_literal: true

module Delegators
  module BoaVistaAcertaEssencial
    extend ActiveSupport::Concern

    included do
      delegate :debit_with_maximum_value, :debit_with_minimum_value,
               :debits_total_value, :days_since_the_last_debit,
               :protested_title_with_maximum_value, :debit_approved?,
               :protested_title_with_minimum_value,
               :protested_titles_total_value, :presumed_income,
               :days_since_the_last_protested_title, :lower_income_value,
               :identification_name, :division_between_income_and_debits_value,
               :identification_birth_date, :debits, :protested_titles,
               :division_between_income_and_protested_title_value,
               to: :boa_vista_acerta_essencial, allow_nil: true,
               prefix: :boa_vista_acerta_essencial
    end
  end
end
