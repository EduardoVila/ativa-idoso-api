# frozen_string_literal: true

module CriminalAntecedentHelpers
  def success_body
    criminal_antecedent_response_path = File.join(
      __dir__,
      '..',
      '..',
      'fixtures',
      'pro_score',
      'criminal_antecedent_response.json'
    )

    File.read(criminal_antecedent_response_path)
  end

  def error_body
    criminal_antecedent_response_path = File.join(
      __dir__,
      '..',
      '..',
      'fixtures',
      'pro_score',
      'error_pro_score_response.json'
    )

    File.read(criminal_antecedent_response_path)
  end

  def url(score)
    url = ENV.fetch('PRO_SCORE_BASE_SEARCH_URL')

    path_params(score).each do |param|
      url += "#{param.first}=#{param.second}&"
    end

    url
  end

  def credentials
    {
      rede: ENV.fetch('PRO_SCORE_REDE'),
      loja: ENV.fetch('PRO_SCORE_LOJA'),
      ctr: ENV.fetch('PRO_SCORE_CTR')
    }
  end

  def path_params(score)
    {
      rede: credentials[:rede],
      loja: credentials[:loja],
      contrato: credentials[:ctr],
      consulta: 267_328,
      tcpfcnpj: score.cpf
    }
  end

  def empty_body_response
    Faraday::Response.new
  end
end
