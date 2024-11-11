# frozen_string_literal: true

# ErrorReportCommand provides error reporting to multiple destinations/services in a centralized way.
# Currently, we're reporting to:
# - Sentry
#
# Since we're using an Error/Exception as argument, we're overriding ActiveCommand serialize/deserialize
# methods to make it possible.
#
class ErrorReportCommand < ApplicationCommand
  attr_reader :err

  def initialize(err)
    @err = err
  end

  def call
    # In a thread to avoid delaying/blocking request response.
    Thread.new do
      sentry_report @err
      # new_relic_report err
    end
  end

  private

  def sentry_report(err)
    Sentry.capture_message err
  end
end
