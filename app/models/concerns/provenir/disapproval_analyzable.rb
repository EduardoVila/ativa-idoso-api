# frozen_string_literal: true

# This concern is responsible to handle lawsuit analyzable objects.

module Provenir
  module DisapprovalAnalyzable
    extend ActiveSupport::Concern

    included do
      def disapproved?
        defendant? && banned_keywords_present? && !exceptionable?
      end
    end
  end
end
