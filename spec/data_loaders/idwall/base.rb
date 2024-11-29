# frozen_string_literal: true

require_relative '../../data_loaders/idwall/base'
require_relative '../../data_loaders/idwall/report'

RSpec.describe DataLoaders::Idwall::Base do
  describe '.parse' do
    let!(:report) { create :idwall_report, status: 'processed' }

    context 'when parse is called' do
      it 'parses plugin cpf' do
        raw_data = '{
          "result": {
            "cpf": {
              "sexo": "M",
              "numero": "636.338.880-55",
              "data_de_nascimento": "25/05/1970",
              "fonte": "RECEITA FEDERAL",
              "nome": "MARCOS EMANUEL SAMUEL DA LUZ",
              "renda": "1 - ATE 2 SM",
              "situacao_imposto_de_renda": "REGULAR",
              "pep": false,
              "cpf_situacao_cadastral": "REGULAR",
              "cpf_data_de_inscricao": "01/10/2000",
              "cpf_digito_verificador": "00",
              "cpf_anterior_1990": "N",
              "ano_obito": "",
              "nome_social": ""
            }
          }
        }'

        data = JSON.parse(raw_data)
        registers = data['result']
        register = registers['cpf']

        gender = register['sexo']
        number = register['numero']
        birth_date = register['data_de_nascimento']
        source = register['fonte']
        name = register['nome']
        income = register['renda']
        income_tax_situation = register['situacao_imposto_de_renda']
        cpf_cadastral_situation = register['cpf_situacao_cadastral']
        cpf_subscription_date = register['cpf_data_de_inscricao']
        cpf_verifying_digit = register['cpf_digito_verificador']
        year_of_death = register['ano_obito']
        social_name = register['nome_social']

        parsed_data = DataLoaders::Idwall::Report.parse(data, report)
        cpf = parsed_data.cpf

        expect(cpf.gender).to eq(gender)
        expect(cpf.number).to eq(number)
        expect(cpf.birth_date).to eq(birth_date)
        expect(cpf.source).to eq(source)
        expect(cpf.name).to eq(name)
        expect(cpf.income).to eq(income)
        expect(cpf.income_tax_situation).to eq(income_tax_situation)
        expect(cpf.cpf_cadastral_situation).to eq(cpf_cadastral_situation)
        expect(cpf.cpf_subscription_date).to eq(cpf_subscription_date)
        expect(cpf.cpf_verifying_digit).to eq(cpf_verifying_digit)
        expect(cpf.year_of_death).to eq(year_of_death)
        expect(cpf.social_name).to eq(social_name)
      end

      it 'parses plugin processos' do
        raw_data = '{
          "result": {
            "processos": {
              "itens": [
                {
                  "assunto": "Locação de Imóvel",
                  "classe": "Despejo por Falta de Pagamento Cumulado",
                  "peticao_inicial": null,
                  "segredo": null,
                  "sigiloso": null,
                  "situacao": null,
                  "tramitacao_preferencial": null,
                  "valor": "R$ 6.192,00",
                  "partes": [
                    {
                      "cnpj": null,
                      "cpf": null,
                      "data_de_nascimento": null,
                      "nome": "Luzia Priscila Brito",
                      "rg": null,
                      "sexo": null,
                      "tipo": null,
                      "titulo": "REQTE"
                    }
                  ]
                }
              ]
            }
          }
        }'

        data = JSON.parse(raw_data)
        result = data['result']
        trials = result['processos']
        registers = trials['itens']
        first_register = registers.first

        subject = first_register['assunto']
        kind = first_register['classe']

        trial_parts = first_register['partes']
        first_trial_part = trial_parts.first

        trial_part_cnpj = first_trial_part['cnpj']
        trial_part_cpf = first_trial_part['cpf']
        trial_part_birth_date = first_trial_part['data_de_nascimento']
        trial_part_name = first_trial_part['nome']
        trial_part_rg = first_trial_part['rg']
        trial_part_gender = first_trial_part['sexo']
        trial_part_kind = first_trial_part['tipo']
        trial_part_title = first_trial_part['titulo']

        parsed_data = DataLoaders::Idwall::Report.parse(data, report)
        trials = parsed_data.trials
        first_trial = trials.first

        trial_parts = first_trial.trial_parts
        first_trial_part = trial_parts.first

        expect(first_trial.subject).to eq(subject)
        expect(first_trial.kind).to eq(kind)

        # Specs for parts of the trial

        expect(first_trial_part.cpf).to eq(trial_part_cpf)
        expect(first_trial_part.cnpj).to eq(trial_part_cnpj)
        expect(first_trial_part.birth_date).to eq(trial_part_birth_date)
        expect(first_trial_part.name).to eq(trial_part_name)
        expect(first_trial_part.rg).to eq(trial_part_rg)
        expect(first_trial_part.gender).to eq(trial_part_gender)
        expect(first_trial_part.kind).to eq(trial_part_kind)
        expect(first_trial_part.title).to eq(trial_part_title)
      end

      it 'parses plugin enderecos' do
        raw_data = '{
          "result": {
            "enderecos": [
              {
                "principal": true,
                "cidade": "CAMPINAS",
                "estado": "SP",
                "numero": "300",
                "cep": "13070165",
                "logradouro": "R RAPOSO NUNES",
                "bairro": "JARDIM CHAPADAO",
                "pessoas_no_endereco": "-1",
                "tipo": "RESIDENCIAL"
              }
            ]
          }
        }'

        data = JSON.parse(raw_data)
        result = data['result']
        addresses = result['enderecos']
        first_register = addresses.first

        main = first_register['assunto']
        city = first_register['classe']
        number = first_register['numero']
        zip_code = first_register['cep']
        state = first_register['estado']
        street = first_register['logradouro']
        neighborhood = first_register['bairro']
        people_at_address = first_register['pessoas_no_endereco']
        kind = first_register['tipo']

        parsed_data = DataLoaders::Idwall::Report.parse(data, report)
        addresses = parsed_data.addresses
        first_register = addresses.first

        expect(first_register.main).to eq(main)
        expect(first_register.city).to eq(city)
        expect(first_register.number).to eq(number)
        expect(first_register.zip_code).to eq(zip_code)
        expect(first_register.state).to eq(state)
        expect(first_register.street).to eq(street)
        expect(first_register.neighborhood).to eq(neighborhood)
        expect(first_register.people_at_address).to eq(people_at_address)
        expect(first_register.kind).to eq(kind)
      end

      it 'parses plugin pessoas_relacionadas' do
        raw_data = '{
          "result": {
            "pessoas_relacionadas": [
              {
                  "cpf": "951.343.849-08",
                  "nome": "LUIZA PRISCILA BRITO",
                  "tipo": "FAMILIA"
              }
            ]
          }
        }'

        data = JSON.parse(raw_data)
        result = data['result']
        registers = result['pessoas_relacionadas']
        first_register = registers.first

        cpf = first_register['cpf']
        name = first_register['nome']
        kind = first_register['tipo']

        parsed_data = DataLoaders::Idwall::Report.parse(data, report)
        related_people = parsed_data.related_people
        first_related_person = related_people.first

        expect(first_related_person.cpf).to eq(cpf)
        expect(first_related_person.name).to eq(name)
        expect(first_related_person.kind).to eq(kind)
      end
    end
  end
end
