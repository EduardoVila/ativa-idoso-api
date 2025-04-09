# frozen_string_literal: true

module Analysis
  module FeeComputable
    extend ActiveSupport::Concern

    included do
      def calculate_fee(prediction)
        result = prediction.fee

        return unless fee.blank? || fee < result

        update(fee: result)
      end
    end
  end
end
