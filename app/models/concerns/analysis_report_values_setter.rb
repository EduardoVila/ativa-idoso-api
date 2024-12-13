# frozen_string_literal: true

module AnalysisReportValuesSetter
  extend ActiveSupport::Concern

  CONTRACT_VALUES = {
    '120' => 119.00,
    '105' => 99.00,
    '95' => 89.00,
    '85' => 59.00,
    '75' => 45.00,
    '65' => 29.00
  }.freeze

  def relate_opening_value(fee)
    CONTRACT_VALUES[fee.to_s.delete('.')]
  end

  included do
    # TODO: correct the fee calculation
    def calculate_fee(prediction)
      result = 0

      if result.blank?
        result = prediction.fee + 2 # we are adding 2% to preserve our cash

        result = 14.0 if prediction.result.to_s.eql?('9.5')

        return unless fee.blank? || fee < result
      end

      update(fee: result)
    end
  end
end
