# frozen_string_literal: true

module ProScore
  class BaseSearchIntegrator < ApplicationIntegrator
    def load_data(analysis_item)
      response = perform_post_request(analysis_item)
      body = parser(response.body)

      raise Errors::ProScore::ResponseError unless response.success?

      save_resource(body, analysis_item)
    end

    private

    def enable_log_response
      true
    end

    def perform_post_request(analysis_item)
      do_request(:post, url(analysis_item), headers)
    end

    def path_params(analysis_item)
      {
        rede: credentials[:rede],
        loja: credentials[:loja],
        contrato: credentials[:ctr],
        consulta: search_id,
        tcpfcnpj: analysis_item.cpf
      }
    end

    def headers
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{ProScore::AuthenticationService.call}"
      }
    end

    def credentials
      {
        rede: ENV.fetch('PRO_SCORE_REDE'),
        loja: ENV.fetch('PRO_SCORE_LOJA'),
        ctr: ENV.fetch('PRO_SCORE_CTR')
      }
    end

    def save_resource(body, analysis_item)
      report = ProScore::Report
        .find_or_initialize_by(analysis_item: analysis_item)

      performed_searches = report.performed_searches << search_name

      report.update(performed_searches: performed_searches)

      return unless body.present?

      data = body['registro']

      return unless data.present?

      report.update(raw_data: data)

      related_plugins.each do |key, value|
        filter_by_plugin(data, value).each do |filtered_data|
          object = Object.const_get("ProScore::#{key}").new
          object.report = report

          object.attributes = formatted_item(filtered_data, object)
          object.save
        end
      end
    end

    def search_name
      klass_model.name.underscore.split('/').last
    end

    def related_plugins
      raise NotImplementedError
    end

    def filter_by_plugin(data, number)
      data.filter { |item| item['numero_plugin'] == number.to_s }
    end

    def url(analysis_item)
      url = ENV.fetch('PRO_SCORE_BASE_SEARCH_URL')

      path_params(analysis_item).each do |param|
        url += "#{param.first}=#{param.second}&"
      end

      url
    end

    def formatted_item(item, object)
      item.filter_map do |key, value|
        unless key != 'id' && value.present? && object.respond_to?(key.to_s)
          next
        end

        { key => value }
      end.reduce(:update)
    end

    def search_id
      raise NotImplementedError
    end
  end
end
