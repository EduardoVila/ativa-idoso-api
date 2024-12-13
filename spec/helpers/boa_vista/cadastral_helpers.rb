# frozen_string_literal: true

module CadastralHelpers
  def request_body(analysis_item, products = %w[LO QA CB])
    unmasked_cpf = CPF::Formatter.strip analysis_item.cpf

    {
      'cpf' => unmasked_cpf,
      'modules' => products.join(',')
    }.to_json
  end

  def success_body
    cadastral_response_path = File.join(
      'spec/fixtures/boa_vista/cadastral_response.json'
    )

    File.read(cadastral_response_path)
  end

  def not_found_body
    cadastral_response_path = File.join(
      'spec/fixtures/boa_vista/response_not_found_cadastral.json'
    )

    File.read(cadastral_response_path)
  end
end
