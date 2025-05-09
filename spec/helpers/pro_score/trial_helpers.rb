# frozen_string_literal: true

module TrialHelpers
  def success_body
    trial_response_path = File.join(
      __dir__, '..', '..', 'fixtures', 'pro_score', 'trial_response.json'
    )

    File.read(trial_response_path)
  end

  def error_body
    trial_response_path = File.join(
      __dir__, '..', '..', 'fixtures', 'pro_score', 'error_trial_response.json'
    )

    File.read(trial_response_path)
  end

  def url(analysis_item)
    url = 'https://proscore.com.br/cns/json.chp?'

    path_params(analysis_item).each do |param|
      url += "#{param.first}=#{param.second}&"
    end

    url
  end

  def credentials
    {
      rde: EnvHelper.fetch('PRO_SCORE_RDE'),
      rdelja: EnvHelper.fetch('PRO_SCORE_RDELJA'),
      ctr: EnvHelper.fetch('PRO_SCORE_CTR'),
      srvcns: EnvHelper.fetch('PRO_SCORE_SRVCNS'),
      tcnscod: EnvHelper.fetch('PRO_SCORE_TCNSCOD')
    }
  end

  def path_params(score)
    {
      rde: credentials[:rde],
      rdelja: credentials[:rdelja],
      ctr: credentials[:ctr],
      srvcns: credentials[:srvcns],
      tcnscod: credentials[:tcnscod],
      tcpfcnpj: score.cpf
    }
  end

  def empty_body_response
    Faraday::Response.new
  end
end
