# frozen_string_literal: true

class ApplicationCommand
  # command API - SpecialCommand.call(*args)
  def self.call(*args)
    new(*args).call
  end

  def call
    raise NotImplementedError
  end
end
