# frozen_string_literal: true

# Module ErrorLogger is a simple error logger that logs errors to:
# - NewRelic
# - Sentry
# - Rails log file
#
# usage
# ----
# ```ruby
# begin
#   something_critial!
# rescue => err
#   ErrorLogger.log err # will log to NewRelic, Sentry and Rails log file
# end
# ```
#
module ErrorLogger
  extend self # to allow using private methods! (module_function will not allow it)

  def log(err)
    # async remote requests
    remote_log(err) if Sinatra::Application.settings.production?

    # sync logging to file
    sinatra_log_err err
  end

  def remote_log(err)
    ErrorReportCommand.call(err)
  end

  private

  def sinatra_log_err(err)
    logger ||= Logger.new($stdout)
    backtrace = err.backtrace

    logger.error err.message
    logger.error backtrace.join("\n") if backtrace
  end
end
