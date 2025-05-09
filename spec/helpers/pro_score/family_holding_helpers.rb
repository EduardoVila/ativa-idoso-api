# frozen_string_literal: true

module FamilyHoldingHelpers
  def success_body
    family_holding_response_path = File.join(
      __dir__,
      '..',
      '..',
      'fixtures',
      'pro_score',
      'family_holding_response.json'
    )

    File.read(family_holding_response_path)
  end

  def error_body
    family_holding_response_path = File.join(
      __dir__, '..', '..', 'fixtures', 'pro_score',
      'error_pro_score_response.json'
    )

    File.read(family_holding_response_path)
  end

  def url(score)
    url = EnvHelper.fetch('PRO_SCORE_BASE_SEARCH_URL')

    path_params(score).each do |param|
      url += "#{param.first}=#{param.second}&"
    end

    url
  end

  def credentials
    {
      rede: EnvHelper.fetch('PRO_SCORE_REDE'),
      loja: EnvHelper.fetch('PRO_SCORE_LOJA'),
      ctr: EnvHelper.fetch('PRO_SCORE_CTR')
    }
  end

  def path_params(score)
    {
      rede: credentials[:rede],
      loja: credentials[:loja],
      contrato: credentials[:ctr],
      consulta: 273_782,
      tcpfcnpj: score.cpf
    }
  end

  def empty_body_response
    Faraday::Response.new
  end
end
