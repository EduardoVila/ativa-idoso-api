# frozen_string_literal: true

module BouncedCheckHelpers
  def success_body
    bounced_check_response_path = File.join(
      __dir__,
      '..',
      '..',
      'fixtures',
      'pro_score',
      'bounced_check_response.json'
    )

    File.read(bounced_check_response_path)
  end

  def error_body
    bounced_check_response_path = File.join(
      __dir__,
      '..',
      '..',
      'fixtures',
      'pro_score',
      'error_pro_score_response.json'
    )

    File.read(bounced_check_response_path)
  end

  def url(analysis_item)
    url = EnvHelper.fetch('PRO_SCORE_BASE_SEARCH_URL')

    path_params(analysis_item).each do |param|
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

  def path_params(analysis_item)
    {
      rede: credentials[:rede],
      loja: credentials[:loja],
      contrato: credentials[:ctr],
      consulta: 273_776,
      tcpfcnpj: analysis_item.cpf
    }
  end

  def empty_body_response
    Faraday::Response.new
  end
end
