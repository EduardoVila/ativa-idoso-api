# frozen_string_literal: true

module Delegators
  module Serasa
    extend ActiveSupport::Concern

    included do
      delegate :negative_data, :registration,
               to: :serasa_fintech_report, prefix: :serasa, allow_nil: true

      delegate :pefin_count, :pefin_total_value, :pefin_maximum_value,
               :pefin_items, :pefin_minimum_value,
               :pefin_days_since_the_last_occurence,
               to: :serasa_negative_data, prefix: :serasa, allow_nil: true

      delegate :refin_count, :refin_total_value, :refin_maximum_value,
               :refin_items, :refin_minimum_value,
               :refin_days_since_the_last_occurence,
               to: :serasa_negative_data, prefix: :serasa, allow_nil: true

      delegate :notary_count, :notary_total_value, :notary_maximum_value,
               :notary_minimum_value, :notary_days_since_the_last_occurence,
               to: :serasa_negative_data, prefix: :serasa, allow_nil: true

      delegate :check_count, :approved?, :debits_count,
               to: :serasa_negative_data, prefix: :serasa_negative_data,
               allow_nil: true

      def serasa_age
        birth_date = serasa_registration.birth_date

        return unless birth_date.present? && valid_datetime?(birth_date)

        birth_date_datetime = birth_date.to_datetime

        today = Time.zone.today
        age = today.year - birth_date_datetime.year
        age -= 1 if today < birth_date_datetime + age.years

        age
      end

      def serasa_days_since_the_last_debit
        a = serasa_pefin_days_since_the_last_occurence || 0
        b = serasa_refin_days_since_the_last_occurence || 0

        [a, b].min
      end

      def serasa_days_since_the_last_protested_title
        serasa_notary_days_since_the_last_occurence
      end

      def serasa_debit_with_maximum_value
        a = serasa_pefin_maximum_value || 0
        b = serasa_refin_maximum_value || 0

        [a, b].max
      end

      def serasa_debit_with_minimum_value
        a = serasa_pefin_minimum_value || 0
        b = serasa_refin_minimum_value || 0

        [a, b].min
      end

      def serasa_debits_total_value
        if serasa_pefin_total_value.blank? && serasa_refin_total_value.blank?
          return 0
        end

        serasa_pefin_total_value + serasa_refin_total_value
      end

      def serasa_protested_title_with_maximum_value
        serasa_notary_maximum_value
      end

      def serasa_protested_title_with_minimum_value
        serasa_notary_minimum_value
      end

      def serasa_protested_titles_total_value
        serasa_notary_total_value
      end

      private

      def valid_datetime?(value)
        !!value.to_datetime
      rescue ArgumentError
        false
      end

      def division(quotient, dividend)
        return unless quotient != 0

        return quotient if dividend.zero?

        quotient / dividend
      end
    end
  end
end
