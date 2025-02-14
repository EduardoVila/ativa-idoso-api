# frozen_string_literal: true

module Validators
  module Test
    module Matchers
      #
      # Validação para CNPJ em atributos
      #
      module ValidateCNPJFor
        extend RSpec::Matchers::DSL

        #
        # RSpec matcher para verificar o casting de tipo de atributos
        #
        # Uso:
        # ```
        # it { is_expected.to validate_cpf_for(:cnpj) }
        # ```
        matcher :validate_cnpj_for do |attribute|
          match do |record|
            expect(record).to allow_values(*%w[
              31.949.349/6031-45
              82.288.083/8257-40
              04.451.749/2719-91
            ]).for(attribute)

            expect(record).not_to allow_values(*%w[
              31.949.349/6031-44
              11.111.111/1111-12
              11.111.111/1111-32
              11.333.111/3333-32
              33.333.333/3333-34
              invalid
            ]).for(attribute)
          end
        end
      end
    end
  end
end
