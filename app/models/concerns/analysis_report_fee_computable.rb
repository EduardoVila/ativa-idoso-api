# frozen_string_literal: true

module AnalysisReportFeeComputable
  extend ActiveSupport::Concern

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
