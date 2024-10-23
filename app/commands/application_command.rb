# frozen_string_literal: true

class ApplicationCommand

  # command API - SpecialCommand.call(*args)
  def self.call(*)
    new(*).call
  end

  def call
    raise NotImplementedError
  end
end
