# frozen_string_literal: true

module AnalysisReportFeeComputable
  extend ActiveSupport::Concern

  included do
    # TODO: correct the fee calculation
    def calculate_fee(prediction)
      result = prediction.fee
      result = 14.0 if prediction.fee.to_s.eql?('9.5')

      return unless fee.blank? || fee < result

      update(fee: result)
    end
  end
end
