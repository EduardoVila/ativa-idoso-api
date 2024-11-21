# frozen_string_literal: true

# EmptyResponseError - specific error in case an integrator returns
# status 200, but with an empty body
# (e.g. it has happened frequently at ProScore.)
#
class EmptyResponseError < StandardError; end
