# frozen_string_literal: true

require_dependency 'integrators/boa_vista'
require_dependency 'data_loaders/boa_vista/base'

module DataLoaders
  module BoaVista
    class AcertaEssencial < Base
      def self.load(cpf, credit_type)
        data = Integrators::BoaVista.acerta_essencial(cpf, credit_type)

        acerta_essencial = parse(cpf, credit_type, data)

        return if acerta_essencial.blank?

        acerta_essencial.raw_data = data

        acerta_essencial
      end
    end
  end
end
