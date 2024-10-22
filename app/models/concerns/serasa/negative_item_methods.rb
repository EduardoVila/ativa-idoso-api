# frozen_string_literal: true

module Serasa
  module NegativeItemMethods
    extend ActiveSupport::Concern

    included do
      delegate :count, to: :items

      def approved?
        items.none?(&:disapproved?)
      end

      def items_amount
        @items_amount ||= items.pluck(:amount)
      end

      def total_value
        items_amount.sum
      end

      def maximum_value
        items_amount.max
      end

      def minimum_value
        items_amount.min
      end

      def days_since_the_last_occurence
        occurrence_dates = items.pluck(:occurrence_date)

        calculate_days_since_last_occurrence(occurrence_dates)
      end

      private

      def calculate_days_since_last_occurrence(dates)
        last_occurrence = dates.max

        return unless last_occurrence

        (Time.zone.today - last_occurrence).to_i
      end
    end
  end
end
