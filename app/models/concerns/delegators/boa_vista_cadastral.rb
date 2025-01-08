# frozen_string_literal: true

module Delegators
  module BoaVistaCadastral
    extend ActiveSupport::Concern

    included do
      delegate :addresses_count, :phones_count, :age, :name,
               to: :boa_vista_cadastral, allow_nil: true,
               prefix: :boa_vista_cadastral
    end
  end
end
