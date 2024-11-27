# frozen_string_literal: true

require 'dotenv/load'

Dotenv.load

module ProScore
  class TrialIntegrator < ApplicationIntegrator
    def load_data(analysis_item)
      response = perform_get_request(analysis_item)
      body = parser(response.body)

      raise Errors::ProScore::ResponseError if response_error?(body)

      save_resource(body, analysis_item)
    end

    private

    def enable_log_response
      true
    end

    def perform_get_request(analysis_item)
      do_request(:get, url(analysis_item), headers)
    end

    def response_error?(body)
      body.blank? ||
        body['registro'].blank? ||
        plugin_error_message(body)
    end

    def plugin_error_message(body)
      plugin = filter_by_plugin(body['registro'], 9).first

      plugin.present? &&
        plugin['descricao_da_mensagem'] == 'CPF/CNPJ DIGITADO E INVALIDO!'
    end

    def path_params(analysis_item)
      {
        rde: credentials[:rde],
        rdelja: credentials[:rdelja],
        ctr: credentials[:ctr],
        srvcns: credentials[:srvcns],
        tcnscod: credentials[:tcnscod],
        tcpfcnpj: analysis_item.cpf
      }
    end

    def headers
      { 'Content-Type' => 'application/json' }
    end

    def credentials
      {
        rde: ENV.fetch('PRO_SCORE_RDE'),
        rdelja: ENV.fetch('PRO_SCORE_RDELJA'),
        ctr: ENV.fetch('PRO_SCORE_CTR'),
        srvcns: ENV.fetch('PRO_SCORE_SRVCNS'),
        tcnscod: ENV.fetch('PRO_SCORE_TCNSCOD')
      }
    end

    def save_resource(body, analysis_item)
      data = body['registro']

      return unless data.present?

      report = ::ProScore::Report.find_or_initialize_by(
        analysis_item: analysis_item
      )

      report.update(
        raw_data: data,
        performed_searches: report.performed_searches << 'trial'
      )

      filter_by_plugin(data, 466).each do |trial|
        object = ::ProScore::Trial.new
        object.report = report

        related_plugins.each do |key, value|
          trial[key] = filter_plugin_by_trial(data, trial, value)
        end

        object.attributes = formatted_item(trial, object)
        object.save
      end
    end

    def related_plugins
      {
        'parts' => 467,
        'lawyers' => 468,
        # 'motions' => 469,
        'topics' => 470
      }
    end

    def filter_plugin_by_trial(data, trial, number)
      data.filter do |item|
        item['numero_plugin'] == number.to_s &&
          item['numero_do_processo_unico'] == trial['numero_do_processo_unico']
      end
    end

    def filter_by_plugin(data, number)
      data.filter { |item| item['numero_plugin'] == number.to_s }
    end

    def url(analysis_item)
      url = ENV.fetch('PRO_SCORE_TRIAL_URL')

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

        if value.is_a? Array # formatting has_many relations (E.g. bills has many receivements)
          value.map! do |item|
            key_class =  Object.const_get(object.public_send(key).name)
            key_object = key_class.new(formatted_item(item, key_class.new))

            key_object
          end
        end

        { key => value }
      end.reduce(:update)
    end
  end
end
