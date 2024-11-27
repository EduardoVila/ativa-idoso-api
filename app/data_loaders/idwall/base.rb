# frozen_string_literal: true

module DataLoaders
  module Idwall
    class Base
      def self.parse(data, report)
        results = data['result']

        return unless results

        # Parse response
        results.keys.each do |key|
          method_name = "parse_#{key}"
          public_send(method_name, results, report) if respond_to? method_name

        end

        report
      end

      def self.formatted_status(status)
        processed?(status) ? 'processed' : 'processing'
      end

      def self.processed?(status)
        ['CONCLUIDO', 'EM ANALISE'].include? status
      end

      def self.parse_cpf(results, report)
        cpf = results['cpf']

        gender = cpf['sexo']
        number = cpf['numero']
        birth_date = cpf['data_de_nascimento']
        source = cpf['fonte']
        name = cpf['nome']
        income = cpf['renda']
        income_tax_situation = cpf['situacao_imposto_de_renda']
        cpf_cadastral_situation = cpf['cpf_situacao_cadastral']
        cpf_subscription_date = cpf['cpf_data_de_inscricao']
        cpf_verifying_digit = cpf['cpf_digito_verificador']
        year_of_death = cpf['ano_obito']
        social_name = cpf['nome_social']

        report.cpf = save_cpf(
          gender, number, birth_date, source, name, income, income_tax_situation,
          cpf_cadastral_situation, cpf_subscription_date, cpf_verifying_digit,
          year_of_death, social_name
        )

        report
      end

      def self.parse_processos(results, report)
        processos = results['processos']

        return report unless processos['itens']

        trials = []

        processos['itens'].each do |item|
          trial_parts = item['partes']

          trial_parts.map! do |trial_part|
            cnpj = trial_part['cnpj']
            cpf = trial_part['cpf']
            birth_date = trial_part['data_de_nascimento']
            name = trial_part['nome']
            rg = trial_part['rg']
            gender = trial_part['sexo']
            kind = trial_part['tipo']
            title = trial_part['titulo']

            save_trial_part(
              cnpj, cpf, birth_date, name, rg, gender, kind, title
            )
          end
          subject = item['assunto']
          kind = item['classe']

          trial = save_trial(subject, kind)

          trial.trial_parts = trial_parts
          trials.push(trial)
        end

        report.trials = trials

        report
      end

      def self.parse_enderecos(results, report)
        addresses = results['enderecos']

        addresses.map! do |address|
          main = address['assunto']
          city = address['classe']
          number = address['numero']
          zip_code = address['cep']
          state = address['estado']
          street = address['logradouro']
          neighborhood = address['bairro']
          people_at_address = address['pessoas_no_endereco']
          kind = address['tipo']

          save_address(
            main, city, number, zip_code, state, street,
            neighborhood, people_at_address, kind
          )
        end

        report.addresses = addresses

        report
      end

      def self.parse_pessoas_relacionadas(results, report)
        related_people = results['pessoas_relacionadas']

        related_people.map! do |related_person|
          cpf = related_person['cpf']
          name = related_person['nome']
          kind = related_person['tipo']

          save_related_person(cpf, name, kind)
        end

        report.related_people = related_people

        report
      end

      def self.save_cpf(
        gender, number, birth_date, source, name, income, income_tax_situation,
        cpf_cadastral_situation, cpf_subscription_date, cpf_verifying_digit,
        year_of_death, social_name
      )
        ::Idwall::CPF.new({
          gender:,
          number:,
          birth_date:,
          source:,
          name:,
          income:,
          income_tax_situation:,
          cpf_cadastral_situation:,
          cpf_subscription_date:,
          cpf_verifying_digit:,
          year_of_death:,
          social_name:
        })
      end

      def self.save_trial(subject, kind)
        ::Idwall::Trial.new({ subject:, kind: })
      end

      def self.save_address(
        main, city, number, zip_code, state, street,
        neighborhood, people_at_address, kind
      )
        ::Idwall::Address.new({
          main:, city:, number:, zip_code:,
          state:, street:, neighborhood:,
          people_at_address:, kind:
        })
      end

      def self.save_related_person(cpf, name, kind)
        ::Idwall::RelatedPerson.new({
          cpf:, name:, kind:
        })
      end

      def self.save_trial_part(
        cnpj, cpf, birth_date, name, rg, gender, kind, title
      )
        ::Idwall::TrialPart.new({
          cnpj:, cpf:, birth_date:, name:, rg:,
          gender:, kind:, title:
        })
      end
    end
  end
end
