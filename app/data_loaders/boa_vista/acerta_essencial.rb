# frozen_string_literal: true

require_relative '../../integrators/boa_vista'
require_relative 'base'

module DataLoaders
  module BoaVista
    class AcertaEssencial < Base
      def self.load(cpf, credit_type)
        data = Integrators::BoaVista.acerta_essencial(cpf, credit_type)

        return if missing_cpf_on_base(data)

        acerta_essencial = parse(cpf, credit_type, data)

        return if acerta_essencial.blank?

        acerta_essencial.raw_data = data

        acerta_essencial
      end

      def self.missing_cpf_on_base(data)
        data.to_s.include?('CPF NAO DISPONIVEL NA BASE')
      end
    end
  end
end
