# frozen_string_literal: true

require 'spec_helper'

require_dependency 'data_loaders/boa_vista/base'
require_dependency 'data_loaders/boa_vista/acerta_essencial'

RSpec.describe DataLoaders::BoaVista::Base do
  describe '.parse acerta essencial' do
    context 'when parse is called' do
      let(:cpf) { Faker::CPF.pretty }
      let(:boa_vista_response_path) do
        File.join(
          __dir__, '..', '..', '..', 'fixtures', 'boa_vista', 'response.xml'
        )
      end
      let(:response_xml) do
        Nokogiri::XML(File.open(boa_vista_response_path)).to_xml
      end
      let(:response) { Hash.from_xml(response_xml) }
      let(:credit_type) { 'CC' }
      let(:acerta_essencial) do
        DataLoaders::BoaVista::AcertaEssencial.parse(
          cpf, credit_type, response
        )
      end

      it 'creates the acerta_essencial correctly' do
        expect(acerta_essencial.cpf).to eq(cpf)
        expect(acerta_essencial.credit_type).to eq(credit_type)
      end

      it 'parses plugin informacoes_complementares' do
        additional_informations = acerta_essencial.additional_informations
        expected_additional_information = response.dig(
          'essencial', 'informacoes_complementares'
        )

        expect(additional_informations).to be_truthy
        expect(additional_informations.length).to eq(1)

        additional_informations.each_with_index do |element, index|
          expect(element.register_size).to eq(
            expected_additional_information['tamanhoRegistro']
          )
          expect(element.register_type).to eq(
            expected_additional_information['tipoRegistro']
          )
          expect(element.register).to eq(
            expected_additional_information['registro']
          )
          expect(element.text).to eq(
            expected_additional_information['texto']
          )
          expect(element.origin).to eq(
            expected_additional_information['origem']
          )
          expect(element.fu_origin).to eq(
            expected_additional_information['ufOrigem']
          )
          expect(element.information_type).to eq(
            expected_additional_information['tipo']
          )
        end
      end

      it 'parses plugin resumoConsultas_anteriores_90_dias' do
        # rubocop:disable Layout/LineLength
        previous90_days_consultation = acerta_essencial.previous90_days_consultation
        # rubocop:enable Layout/LineLength
        expected_previous90_days_consultation = response.dig(
          'essencial', 'resumoConsultas_anteriores_90_dias'
        )

        expect(previous90_days_consultation).to be_truthy

        expect(previous90_days_consultation.register_size).to eq(
          expected_previous90_days_consultation['tamanhoRegistro']
        )
        expect(previous90_days_consultation.register_type).to eq(
          expected_previous90_days_consultation['tipoRegistro']
        )
        expect(previous90_days_consultation.register).to eq(
          expected_previous90_days_consultation['registro']
        )
        expect(previous90_days_consultation.total).to eq(
          expected_previous90_days_consultation['total']
        )
        expect(previous90_days_consultation.year_1).to eq(
          expected_previous90_days_consultation['ano_1']
        )
        expect(previous90_days_consultation.month_1).to eq(
          expected_previous90_days_consultation['mes_1']
        )
        expect(previous90_days_consultation.total_1).to eq(
          expected_previous90_days_consultation['total_1']
        )
        expect(previous90_days_consultation.year_2).to eq(
          expected_previous90_days_consultation['ano_2']
        )
        expect(previous90_days_consultation.month_2).to eq(
          expected_previous90_days_consultation['mes_2']
        )
        expect(previous90_days_consultation.total_2).to eq(
          expected_previous90_days_consultation['total_2']
        )
        expect(previous90_days_consultation.year_3).to eq(
          expected_previous90_days_consultation['ano_3']
        )
        expect(previous90_days_consultation.month_3).to eq(
          expected_previous90_days_consultation['mes_3']
        )
        expect(previous90_days_consultation.total_3).to eq(
          expected_previous90_days_consultation['total_3']
        )
        expect(previous90_days_consultation.year_4).to eq(
          expected_previous90_days_consultation['ano_4']
        )
        expect(previous90_days_consultation.month_4).to eq(
          expected_previous90_days_consultation['mes_4']
        )
        expect(previous90_days_consultation.total_4).to eq(
          expected_previous90_days_consultation['total_4']
        )
      end

      it 'parses plugin resumo_ocorrencias_de_debitos' do
        debit_occurrence = acerta_essencial.debit_occurrence
        expected_debit_occurrence = response.dig(
          'essencial', 'resumo_ocorrencias_de_debitos'
        )

        expect(debit_occurrence).to be_truthy

        expect(debit_occurrence.register_size).to eq(
          expected_debit_occurrence['tamanhoRegistro']
        )
        expect(debit_occurrence.register_type).to eq(
          expected_debit_occurrence['tipoRegistro']
        )
        expect(debit_occurrence.register).to eq(
          expected_debit_occurrence['registro']
        )
        expect(debit_occurrence.total_debtor).to eq(
          expected_debit_occurrence['totalDevedor']
        )
        expect(debit_occurrence.total_guarantor).to eq(
          expected_debit_occurrence['totalAvalista']
        )
        expect(debit_occurrence.accumulated_value).to eq(
          expected_debit_occurrence['valorAcomulado']
        )
        expect(debit_occurrence.first_debit_value).to eq(
          expected_debit_occurrence['valorPrimeiroDebito']
        )
        expect(debit_occurrence.biggest_debit_value).to eq(
          expected_debit_occurrence['valorMaiorDebito']
        )
      end

      context 'parses plugin debitos' do
        context 'when there are not debitos' do
          let(:acerta_essencial) do
            DataLoaders::BoaVista::AcertaEssencial.parse(
              cpf,
              credit_type,
              {
                'essencial' => {
                  'debitos' => []
                }
              }
            )
          end

          it 'returns no debits' do
            debits = acerta_essencial.debits

            expect(debits.length).to eq(0)
          end
        end

        context 'when the debit have missing data' do
          let(:acerta_essencial) do
            DataLoaders::BoaVista::AcertaEssencial.parse(
              cpf,
              credit_type,
              {
                'essencial' => {
                  'debitos' => [{
                    'tamanhoRegistro' => '004',
                    'tipoRegistro' => '124',
                    'registro' => 'N'
                  }]
                }
              }
            )
          end

          it 'returns no debits' do
            debits = acerta_essencial.debits

            expect(debits.length).to eq(0)
          end
        end

        context 'when there are debitos' do
          it 'returns debits correctly' do
            debits = acerta_essencial.debits
            expected_debit = response.dig('essencial', 'debitos')

            expect(debits).to be_truthy
            expect(debits.length).to eq(2)

            debits.each_with_index do |element, index|
              expect(element.register_size).to eq(
                expected_debit[index]['tamanhoRegistro']
              )
              expect(element.register_type).to eq(
                expected_debit[index]['tipoRegistro']
              )
              expect(element.register).to eq(expected_debit[index]['registro'])
              expect(element.occurrence_type).to eq(
                expected_debit[index]['tipoOcorrencia']
              )
              expect(element.contract).to eq(expected_debit[index]['contrato'])
              expect(element.currency).to eq(expected_debit[index]['moeda'])
              expect(element.value).to eq(expected_debit[index]['valor'])
              expect(element.condition).to eq(expected_debit[index]['situacao'])
              expect(element.informant).to eq(
                expected_debit[index]['informante']
              )
              expect(element.informed_by_querent).to eq(
                expected_debit[index]['informadoPeloConsulente']
              )
            end
          end
        end
      end

      context 'parses plugin consultas_anteriores' do
        context 'when there are not consultas_anteriores' do
          let(:acerta_essencial) do
            DataLoaders::BoaVista::AcertaEssencial.parse(
              cpf,
              credit_type,
              {
                'essencial' => {
                  'consultas_anteriores' => []
                }
              }
            )
          end

          it 'returns no previous_queries' do
            previous_queries = acerta_essencial.previous_queries

            expect(previous_queries.length).to eq(0)
          end
        end
      end

      context 'plugin titulos_protestados' do
        context 'when there are not titlos_protestados' do
          let(:acerta_essencial) do
            DataLoaders::BoaVista::AcertaEssencial.parse(
              cpf,
              credit_type,
              {
                'essencial' => {
                  'titlos_protestados' => []
                }
              }
            )
          end

          it 'returns no previous_queries' do
            protested_titles = acerta_essencial.protested_titles

            expect(protested_titles.length).to eq(0)
          end
        end

        context 'when the protested_title have missing data' do
          let(:acerta_essencial) do
            DataLoaders::BoaVista::AcertaEssencial.parse(
              cpf,
              credit_type,
              {
                'essencial' => {
                  'titulos_protestados' => [{
                    'tamanhoRegistro' => '004',
                    'tipoRegistro' => '142',
                    'registro' => 'N'
                  }]
                }
              }
            )
          end

          it 'returns no protested_titles' do
            protested_titles = acerta_essencial.protested_titles

            expect(protested_titles.length).to eq(0)
          end
        end

        context 'when there are titulos_protestados' do
          it 'returns previous_queries correctly' do
            protested_titles = acerta_essencial.protested_titles
            expected_protested_titles = response.dig(
              'essencial', 'titulos_protestados'
            )

            expect(protested_titles).to be_truthy
            expect(protested_titles.length).to eq(2)

            protested_titles.each_with_index do |element, index|
              expect(element.register_size).to eq(
                expected_protested_titles[index]['tamanhoRegistro']
              )
              expect(element.register_type).to eq(
                expected_protested_titles[index]['tipoRegistro']
              )
              expect(element.register).to eq(
                expected_protested_titles[index]['registro']
              )
              expect(element.occurrence_type).to eq(
                expected_protested_titles[index]['tipoOcorrencia']
              )
              expect(element.registry).to eq(
                expected_protested_titles[index]['cartorio']
              )
              expect(element.occurrence_date).to eq(
                expected_protested_titles[index]['dataOcorrencia']
              )
              expect(element.currency).to eq(
                expected_protested_titles[index]['moeda']
              )
              expect(element.value).to eq(
                expected_protested_titles[index]['valor']
              )
              expect(element.city).to eq(
                expected_protested_titles[index]['cidade']
              )
              expect(element.federative_unit).to eq(
                expected_protested_titles[index]['uf']
              )
            end
          end
        end
      end

      it 'parses plugin resumo_titulos_protestados' do
        protested_title_summary = acerta_essencial.protested_title_summary
        expected_protested_title_summary = response.dig(
          'essencial', 'resumo_titulos_protestados'
        )

        expect(protested_title_summary).to be_truthy

        expect(protested_title_summary.register_size).to eq(
          expected_protested_title_summary['tamanhoRegistro']
        )
        expect(protested_title_summary.register_type).to eq(
          expected_protested_title_summary['tipoRegistro']
        )
        expect(protested_title_summary.register).to eq(
          expected_protested_title_summary['registro']
        )
        expect(protested_title_summary.total).to eq(
          expected_protested_title_summary['total']
        )
        expect(protested_title_summary.initial_period).to eq(
          expected_protested_title_summary['periodoInicial']
        )
        expect(protested_title_summary.final_period).to eq(
          expected_protested_title_summary['periodoFinal']
        )
        expect(protested_title_summary.currency).to eq(
          expected_protested_title_summary['moeda']
        )
        expect(protested_title_summary.accumulated_value).to eq(
          expected_protested_title_summary['valorAcumulado']
        )
        expect(protested_title_summary.federative_unit).to eq(
          expected_protested_title_summary['uf']
        )
      end

      it 'parses plugin historico_conta_corrente_informada' do
        acerta_essencial = DataLoaders::BoaVista::AcertaEssencial.parse(
          cpf, credit_type, response
        )
        current_account_historic = acerta_essencial.current_account_historic
        expected_current_account_historic = response.dig(
          'essencial', 'historico_conta_corrente_informada'
        )

        expect(current_account_historic).to be_truthy

        expect(current_account_historic.register_size).to eq(
          expected_current_account_historic['tamanhoRegistro']
        )
        expect(current_account_historic.register_type).to eq(
          expected_current_account_historic['tipoRegistro']
        )
        expect(current_account_historic.register).to eq(
          expected_current_account_historic['registro']
        )
        expect(current_account_historic.bank).to eq(
          expected_current_account_historic['banco']
        )
        expect(current_account_historic.agency).to eq(
          expected_current_account_historic['agencia']
        )
        expect(current_account_historic.current_account).to eq(
          expected_current_account_historic['contaCorrente']
        )
        expect(current_account_historic.document_type).to eq(
          expected_current_account_historic['tipoDocumento']
        )
        expect(current_account_historic.document_number).to eq(
          expected_current_account_historic['numeroDocumento']
        )
        expect(current_account_historic.consultation_date).to eq(
          expected_current_account_historic['dataConsulta']
        )
        expect(current_account_historic.consultation_hour).to eq(
          expected_current_account_historic['horaConsulta']
        )
      end

      it 'parses plugin identificacao' do
        identification = acerta_essencial.identification
        expected_identification = response.dig('essencial', 'identificacao')

        expect(identification).to be_truthy

        expect(identification.register_size).to eq(
          expected_identification['tamanhoRegistro']
        )
        expect(identification.register).to eq(
          expected_identification['registro']
        )
        expect(identification.document).to eq(
          expected_identification['documento']
        )
        expect(identification.name).to eq(expected_identification['nome'])
        expect(identification.mother_name).to eq(
          expected_identification['nomeMae']
        )
        expect(identification.rg_number).to eq(
          expected_identification['numeroRG']
        )
        expect(identification.emitting_organ).to eq(
          expected_identification['orgaoEmissor']
        )
        expect(identification.rg_federative_unit).to eq(
          expected_identification['unidadeFedarativaRG']
        )
        expect(identification.consulted_gender).to eq(
          expected_identification['sexoConsultado']
        )
        expect(identification.birth_city).to eq(
          expected_identification['cidadeNascimento']
        )
        expect(identification.marital_status).to eq(
          expected_identification['estadoCivil']
        )
        expect(identification.dependent_number).to eq(
          expected_identification['numeroDependentes']
        )
        expect(identification.educational_level).to eq(
          expected_identification['grauInstrucao']
        )
        expect(identification.revenue_situation).to eq(
          expected_identification['situacaoReceita']
        )
        expect(identification.cpf_zone).to eq(
          expected_identification['regiaoCpf']
        )
        expect(identification.voter_title).to eq(
          expected_identification['tituloEleitor']
        )
        expect(identification.death).to eq(
          expected_identification['obito']
        )
      end

      it 'parses plugin decisao' do
        decision = acerta_essencial.decision
        expected_decision = response.dig('essencial', 'decisao')

        expect(decision).to be_truthy

        expect(decision.register_size).to eq(
          expected_decision['tamanhoRegistro']
        )
        expect(decision.register_type).to eq(expected_decision['tipoRegistro'])
        expect(decision.register).to eq(expected_decision['registro'])
        expect(decision.document_type).to eq(expected_decision['tipoDocumento'])
        expect(decision.document).to eq(expected_decision['documento'])
        expect(decision.score).to eq(expected_decision['score'])
        expect(decision.approves).to eq(expected_decision['aprova'])
        expect(decision.text).to eq(expected_decision['texto'])
      end

      it 'parses plugin localizacao' do
        location = acerta_essencial.location
        expected_location = response.dig('essencial', 'localizacao')

        expect(location).to be_truthy

        expect(location.register_type).to eq(expected_location['tipoRegistro'])
        expect(location.register_size).to eq(
          expected_location['tamanhoRegistro']
        )
        expect(location.register).to eq(expected_location['registro'])
        expect(location.public_place_type).to eq(
          expected_location['tipoLogradouro']
        )
        expect(location.public_place_name).to eq(
          expected_location['nomeLogradouro']
        )
        expect(location.public_place_number).to eq(
          expected_location['numeroLogradouro']
        )
        expect(location.complement).to eq(expected_location['complemento'])
        expect(location.neighborhood).to eq(expected_location['bairro'])
        expect(location.city).to eq(expected_location['cidade'])
        expect(location.federative_unit).to eq(
          expected_location['unidadeFederativa']
        )
        expect(location.zip_code).to eq(expected_location['cep'])
        expect(location.ddd_1).to eq(expected_location['ddd_1'])
        expect(location.phone_1).to eq(expected_location['telefone_1'])
        expect(location.ddd_2).to eq(expected_location['ddd_2'])
        expect(location.phone_2).to eq(expected_location['telefone_2'])
        expect(location.ddd_3).to eq(expected_location['ddd_3'])
        expect(location.phone_3).to eq(expected_location['telefone_3'])
      end

      it 'parses plugin informacoes_complementares_cheque' do
        # rubocop:disable Layout/LineLength
        cheque_additional_information = acerta_essencial.cheque_additional_information
        # rubocop:enable Layout/LineLength
        expected_cheque_additional_information = response.dig(
          'essencial', 'informacoes_complementares_cheque'
        )

        expect(cheque_additional_information).to be_truthy

        expect(cheque_additional_information.register_type).to eq(
          expected_cheque_additional_information['tipoRegistro']
        )
        expect(cheque_additional_information.register_size).to eq(
          expected_cheque_additional_information['tamanhoRegistro']
        )
        expect(cheque_additional_information.register).to eq(
          expected_cheque_additional_information['registro']
        )
        expect(cheque_additional_information.document_type).to eq(
          expected_cheque_additional_information['tipoDocumento']
        )
        expect(cheque_additional_information.document_number).to eq(
          expected_cheque_additional_information['numeroDocumento']
        )
        expect(cheque_additional_information.text).to eq(
          expected_cheque_additional_information['texto']
        )
        expect(cheque_additional_information.type_of_register).to eq(
          expected_cheque_additional_information['tipoDoRegistro']
        )
      end

      it 'parses plugin confirmacao_cep' do
        zip_code_confirmation = acerta_essencial.zip_code_confirmation
        expected_zip_code_confirmation = response.dig(
          'essencial', 'confirmacao_cep'
        )

        expect(zip_code_confirmation).to be_truthy

        expect(zip_code_confirmation.register_size).to eq(
          expected_zip_code_confirmation['tamanhoRegistro']
        )
        expect(zip_code_confirmation.register_type).to eq(
          expected_zip_code_confirmation['tipoRegistro']
        )
        expect(zip_code_confirmation.register).to eq(
          expected_zip_code_confirmation['registro']
        )
        expect(zip_code_confirmation.zip_code).to eq(
          expected_zip_code_confirmation['cep']
        )
        expect(zip_code_confirmation.address).to eq(
          expected_zip_code_confirmation['endereco']
        )
        expect(zip_code_confirmation.neighborhood).to eq(
          expected_zip_code_confirmation['bairro']
        )
        expect(zip_code_confirmation.city).to eq(
          expected_zip_code_confirmation['cidade']
        )
        expect(zip_code_confirmation.federative_unit).to eq(
          expected_zip_code_confirmation['uf']
        )
      end

      it 'parses plugin nome_documentos' do
        documents_name = acerta_essencial.documents_name
        expected_documents_name = response.dig(
          'essencial', 'nome_documentos'
        )

        expect(documents_name).to be_truthy

        expect(documents_name.register_size).to eq(
          expected_documents_name['tamanhoRegistro']
        )
        expect(documents_name.register_type).to eq(
          expected_documents_name['tipoRegistro']
        )
        expect(documents_name.register).to eq(
          expected_documents_name['registro']
        )
        expect(documents_name.name).to eq(
          expected_documents_name['nome']
        )
        expect(documents_name.birth_date).to eq(
          expected_documents_name['nascimento']
        )
        expect(documents_name.document_type).to eq(
          expected_documents_name['tipoDocumento']
        )
        expect(documents_name.document_number).to eq(
          expected_documents_name['numeroDocumento']
        )
        expect(documents_name.document_2).to eq(
          expected_documents_name['documento_2']
        )
        expect(documents_name.document_3).to eq(
          expected_documents_name['documento_3']
        )
      end

      it 'parses plugin relacao_devolucoes_informadas_pelo_ccf' do
        # rubocop:disable Layout/LineLength
        list_of_returns_reported_by_ccfs = acerta_essencial.list_of_returns_reported_by_ccfs
        # rubocop:enable Layout/LineLength
        expected_list_of_returns_reported_by_ccfs = [response.dig(
          'essencial', 'relacao_devolucoes_informadas_pelo_ccf'
        )]

        expect(list_of_returns_reported_by_ccfs).to be_truthy
        expect(list_of_returns_reported_by_ccfs.length).to eq(1)

        list_of_returns_reported_by_ccfs.each_with_index do |element, index|
          expect(element.register_size).to eq(
            expected_list_of_returns_reported_by_ccfs[index]['tamanhoRegistro']
          )
          expect(element.register_type).to eq(
            expected_list_of_returns_reported_by_ccfs[index]['tipoRegistro']
          )
          expect(element.register).to eq(
            expected_list_of_returns_reported_by_ccfs[index]['registro']
          )
          expect(element.document_type).to eq(
            expected_list_of_returns_reported_by_ccfs[index]['tipoDocumento']
          )
          expect(element.document_number).to eq(
            expected_list_of_returns_reported_by_ccfs[index]['numeroDocumento']
          )
          expect(element.name).to eq(
            expected_list_of_returns_reported_by_ccfs[index]['nome']
          )
          expect(element.bank).to eq(
            expected_list_of_returns_reported_by_ccfs[index]['banco']
          )
          expect(element.agency).to eq(
            expected_list_of_returns_reported_by_ccfs[index]['agencia']
          )
          expect(element.reason_12).to eq(
            expected_list_of_returns_reported_by_ccfs[index]['motivo_12']
          )
          expect(element.last_occurrence_12_date).to eq(
            expected_list_of_returns_reported_by_ccfs[index][
              'data_ultima_ocorrencia_12'
            ]
          )
          expect(element.reason_13).to eq(
            expected_list_of_returns_reported_by_ccfs[index]['motivo_13']
          )
          expect(element.last_occurrence_13_date).to eq(
            expected_list_of_returns_reported_by_ccfs[index][
              'data_ultima_ocorrencia_13'
            ]
          )
          expect(element.reason_14).to eq(
            expected_list_of_returns_reported_by_ccfs[index]['motivo_14']
          )
          expect(element.last_occurrence_14_date).to eq(
            expected_list_of_returns_reported_by_ccfs[index][
              'data_ultima_ocorrencia_14'
            ]
          )
          expect(element.reason_99).to eq(
            expected_list_of_returns_reported_by_ccfs[index]['motivo_99']
          )
          expect(element.last_occurrence_99_date).to eq(
            expected_list_of_returns_reported_by_ccfs[index][
              'data_ultima_ocorrencia_99'
            ]
          )
          expect(element.bank_name).to eq(
            expected_list_of_returns_reported_by_ccfs[index]['nomeBanco']
          )
        end
      end

      it 'parses plugin devolucoes_informadas_pelo_usuario' do
        returns_reported_by_user = acerta_essencial.returns_reported_by_user
        expected_returns_reported_by_user = response.dig(
          'essencial', 'devolucoes_informadas_pelo_usuario'
        )

        expect(returns_reported_by_user).to be_truthy

        expect(returns_reported_by_user.register_size).to eq(
          expected_returns_reported_by_user['tamanhoRegistro']
        )
        expect(returns_reported_by_user.register_type).to eq(
          expected_returns_reported_by_user['tipoRegistro']
        )
        expect(returns_reported_by_user.register).to eq(
          expected_returns_reported_by_user['registro']
        )
        expect(returns_reported_by_user.document_type).to eq(
          expected_returns_reported_by_user['tipoDocumento']
        )
        expect(returns_reported_by_user.document).to eq(
          expected_returns_reported_by_user['documento']
        )
        expect(returns_reported_by_user.bank).to eq(
          expected_returns_reported_by_user['banco']
        )
        expect(returns_reported_by_user.agency).to eq(
          expected_returns_reported_by_user['agencia']
        )
        expect(returns_reported_by_user.current_account).to eq(
          expected_returns_reported_by_user['contaCorrente']
        )
        expect(returns_reported_by_user.initial_cheque).to eq(
          expected_returns_reported_by_user['chequeInicial']
        )
        expect(returns_reported_by_user.final_cheque).to eq(
          expected_returns_reported_by_user['chequeFinal']
        )
        expect(returns_reported_by_user.reason).to eq(
          expected_returns_reported_by_user['motivo']
        )
        expect(returns_reported_by_user.point).to eq(
          expected_returns_reported_by_user['alinea']
        )
        expect(returns_reported_by_user.occurrence_date).to eq(
          expected_returns_reported_by_user['dataOcorrencia']
        )
        expect(returns_reported_by_user.register_date).to eq(
          expected_returns_reported_by_user['dataRegistro']
        )
        expect(returns_reported_by_user.currency).to eq(
          expected_returns_reported_by_user['moeda']
        )
        expect(returns_reported_by_user.value).to eq(
          expected_returns_reported_by_user['valor']
        )
        expect(returns_reported_by_user.informant_code).to eq(
          expected_returns_reported_by_user['codigoInformante']
        )
        expect(returns_reported_by_user.informant).to eq(
          expected_returns_reported_by_user['informante']
        )
        expect(returns_reported_by_user.city).to eq(
          expected_returns_reported_by_user['cidade']
        )
        expect(returns_reported_by_user.federative_unit).to eq(
          expected_returns_reported_by_user['uf']
        )
      end

      it 'parses plugin cheques_sustados_pelo_motivo_21' do
        # rubocop:disable Layout/LineLength
        cheques_stopped_for_reason21 = acerta_essencial.cheques_stopped_for_reason21
        # rubocop:enable Layout/LineLength
        expected_cheques_stopped_for_reason21 = response.dig(
          'essencial', 'cheques_sustados_pelo_motivo_21'
        )

        expect(cheques_stopped_for_reason21).to be_truthy

        expect(cheques_stopped_for_reason21.register_size).to eq(
          expected_cheques_stopped_for_reason21['tamanhoRegistro']
        )
        expect(cheques_stopped_for_reason21.register_type).to eq(
          expected_cheques_stopped_for_reason21['tipoRegistro']
        )
        expect(cheques_stopped_for_reason21.register).to eq(
          expected_cheques_stopped_for_reason21['registro']
        )
        expect(cheques_stopped_for_reason21.document_type).to eq(
          expected_cheques_stopped_for_reason21['tipoDocumento']
        )
        expect(cheques_stopped_for_reason21.document_number).to eq(
          expected_cheques_stopped_for_reason21['numeroDocumento']
        )
        expect(cheques_stopped_for_reason21.bank).to eq(
          expected_cheques_stopped_for_reason21['banco']
        )
        expect(cheques_stopped_for_reason21.agency).to eq(
          expected_cheques_stopped_for_reason21['agencia']
        )
        expect(cheques_stopped_for_reason21.current_account).to eq(
          expected_cheques_stopped_for_reason21['contaCorrente']
        )
        expect(cheques_stopped_for_reason21.initial_cheque).to eq(
          expected_cheques_stopped_for_reason21['chequeInicial']
        )
        expect(cheques_stopped_for_reason21.final_cheque).to eq(
          expected_cheques_stopped_for_reason21['chequeFinal']
        )
        expect(cheques_stopped_for_reason21.point).to eq(
          expected_cheques_stopped_for_reason21['alinea']
        )
        expect(cheques_stopped_for_reason21.occurrence_date).to eq(
          expected_cheques_stopped_for_reason21['dataOcorrencia']
        )
        expect(cheques_stopped_for_reason21.availability_date).to eq(
          expected_cheques_stopped_for_reason21['dataDisponibilizacao']
        )
        expect(cheques_stopped_for_reason21.currency).to eq(
          expected_cheques_stopped_for_reason21['moeda']
        )
        expect(cheques_stopped_for_reason21.value).to eq(
          expected_cheques_stopped_for_reason21['valor']
        )
        expect(cheques_stopped_for_reason21.informant).to eq(
          expected_cheques_stopped_for_reason21['informante']
        )
      end

      it 'parses plugin historico_cheque_informado' do
        historic_informed_cheque = acerta_essencial.historic_informed_cheque
        expected_historic_informed_cheque = response.dig(
          'essencial', 'historico_cheque_informado'
        )

        expect(historic_informed_cheque).to be_truthy

        expect(historic_informed_cheque.register_size).to eq(
          expected_historic_informed_cheque['tamanhoRegistro']
        )
        expect(historic_informed_cheque.register_type).to eq(
          expected_historic_informed_cheque['tipoRegistro']
        )
        expect(historic_informed_cheque.register).to eq(
          expected_historic_informed_cheque['registro']
        )
        expect(historic_informed_cheque.document_type).to eq(
          expected_historic_informed_cheque['tipoDocumento']
        )
        expect(historic_informed_cheque.document_number).to eq(
          expected_historic_informed_cheque['numeroDocumento']
        )
        expect(historic_informed_cheque.bank).to eq(
          expected_historic_informed_cheque['banco']
        )
        expect(historic_informed_cheque.agency).to eq(
          expected_historic_informed_cheque['agencia']
        )
        expect(historic_informed_cheque.current_account).to eq(
          expected_historic_informed_cheque['contaCorrente']
        )
        expect(historic_informed_cheque.cheque).to eq(
          expected_historic_informed_cheque['cheque']
        )
        expect(historic_informed_cheque.consultation_date).to eq(
          expected_historic_informed_cheque['dataConsulta']
        )
        expect(historic_informed_cheque.consultation_hour).to eq(
          expected_historic_informed_cheque['horaConsulta']
        )
        expect(historic_informed_cheque.network).to eq(
          expected_historic_informed_cheque['rede']
        )
      end

      it 'parses plugin consultas_anteriores_cheque' do
        # rubocop:disable Layout/LineLength
        previous_cheque_consultation = acerta_essencial.previous_cheque_consultation
        # rubocop:enable Layout/LineLength
        expected_previous_cheque_consultation = response.dig(
          'essencial', 'consultas_anteriores_cheque'
        )

        expect(previous_cheque_consultation).to be_truthy

        expect(previous_cheque_consultation.register_size).to eq(
          expected_previous_cheque_consultation['tamanhoRegistro']
        )
        expect(previous_cheque_consultation.register_type).to eq(
          expected_previous_cheque_consultation['tipoRegistro']
        )
        expect(previous_cheque_consultation.register).to eq(
          expected_previous_cheque_consultation['registro']
        )
        expect(previous_cheque_consultation.document_type).to eq(
          expected_previous_cheque_consultation['tipoDocumento']
        )
        expect(previous_cheque_consultation.document_number).to eq(
          expected_previous_cheque_consultation['numeroDocumento']
        )
        expect(previous_cheque_consultation.consultation_type).to eq(
          expected_previous_cheque_consultation['tipo']
        )
        expect(previous_cheque_consultation.credit_date).to eq(
          expected_previous_cheque_consultation['dataCredito']
        )
        expect(previous_cheque_consultation.credit_hour).to eq(
          expected_previous_cheque_consultation['horaCredito']
        )
        expect(previous_cheque_consultation.currency).to eq(
          expected_previous_cheque_consultation['moeda']
        )
        expect(previous_cheque_consultation.value).to eq(
          expected_previous_cheque_consultation['valor']
        )
        expect(previous_cheque_consultation.informant).to eq(
          expected_previous_cheque_consultation['informante']
        )
      end

      it 'parses plugin resumo_devolucoes_informada_pelo_usuario' do
        # rubocop:disable Layout/LineLength
        summary_of_returns_reported_by_user = acerta_essencial.summary_of_returns_reported_by_user
        # rubocop:enable Layout/LineLength
        expected_summary_of_returns_reported_by_user = response.dig(
          'essencial', 'resumo_devolucoes_informada_pelo_usuario'
        )

        expect(summary_of_returns_reported_by_user).to be_truthy

        expect(summary_of_returns_reported_by_user.register_size).to eq(
          expected_summary_of_returns_reported_by_user['tamanhoRegistro']
        )
        expect(summary_of_returns_reported_by_user.register_type).to eq(
          expected_summary_of_returns_reported_by_user['tipoRegistro']
        )
        expect(summary_of_returns_reported_by_user.register).to eq(
          expected_summary_of_returns_reported_by_user['registro']
        )
        expect(summary_of_returns_reported_by_user.document_type).to eq(
          expected_summary_of_returns_reported_by_user['tipoDocumento']
        )
        expect(summary_of_returns_reported_by_user.document_number).to eq(
          expected_summary_of_returns_reported_by_user['numeroDocumento']
        )
        expect(summary_of_returns_reported_by_user.total).to eq(
          expected_summary_of_returns_reported_by_user['total']
        )
        expect(summary_of_returns_reported_by_user.first_devolution_date).to eq(
          expected_summary_of_returns_reported_by_user['dataPrimeiraDevolucao']
        )
        expect(summary_of_returns_reported_by_user.last_devolution_date).to eq(
          expected_summary_of_returns_reported_by_user['dataUltimaDevolucao']
        )
      end

      context 'parses plugin score_classificacao_varios_modelos' do
        context 'when there are not score_classificacao_varios_modelos' do
          let(:acerta_essencial) do
            DataLoaders::BoaVista::AcertaEssencial.parse(
              cpf,
              credit_type,
              {
                'essencial' => {
                  'score_classificacao_varios_modelos' => []
                }
              }
            )
          end

          it 'returns no score_rating_several_models' do
            score_rating_several_models = acerta_essencial
              .score_rating_several_models

            expect(score_rating_several_models.length).to eq(0)
          end
        end

        context 'when there are score_classificacao_varios_modelos' do
          it 'returns score_rating_several_models correctly' do
            score_rating_several_models = acerta_essencial
              .score_rating_several_models
            expected_score_rating_several_model = response.dig(
              'essencial', 'score_classificacao_varios_modelos'
            )

            expect(score_rating_several_models).to be_truthy
            expect(score_rating_several_models.length).to eq(2)

            score_rating_several_models.each_with_index do |element, index|
              expect(element.register_size).to eq(
                expected_score_rating_several_model[index]['tamanhoRegistro']
              )
              expect(element.register_type).to eq(
                expected_score_rating_several_model[index]['tipoRegistro']
              )
              expect(element.register).to eq(
                expected_score_rating_several_model[index]['registro']
              )
              expect(element.score_type).to eq(
                expected_score_rating_several_model[index]['tipoScore']
              )
              expect(element.score).to eq(
                expected_score_rating_several_model[index]['score']
              )
              expect(element.plan_name).to eq(
                expected_score_rating_several_model[index]['nomePlano']
              )
              expect(element.score_model).to eq(
                expected_score_rating_several_model[index]['modeloScore']
              )
              expect(element.score_name).to eq(
                expected_score_rating_several_model[index]['nomeScore']
              )
              expect(element.numeric_classification).to eq(
                expected_score_rating_several_model[index][
                  'classificacaoNumerica'
                ]
              )
              expect(element.alphabetic_classification).to eq(
                expected_score_rating_several_model[index][
                  'classificacaoAlfabetica'
                ]
              )
              expect(element.probability).to eq(
                expected_score_rating_several_model[index]['probabilidade']
              )
              expect(element.text).to eq(
                expected_score_rating_several_model[index]['texto']
              )
              expect(element.code_kind_model).to eq(
                expected_score_rating_several_model[index][
                  'codigoNaturezaModelo'
                ]
              )
              expect(element.kind_description).to eq(
                expected_score_rating_several_model[index]['descricaoNatureza']
              )
              expect(element.text_2).to eq(
                expected_score_rating_several_model[index]['texto2']
              )
            end
          end
        end
      end

      it 'parses plugin mensagem_registro' do
        record_message = acerta_essencial.record_message
        expected_record_message = response.dig(
          'essencial', 'mensagem_registro'
        )

        expect(record_message).to be_truthy

        expect(record_message.register_size).to eq(
          expected_record_message['tamanhoRegistro']
        )
        expect(record_message.register_type).to eq(
          expected_record_message['tipoRegistro']
        )
        expect(record_message.register).to eq(
          expected_record_message['registro']
        )
        expect(record_message.record_reference).to eq(
          expected_record_message['registroReferencia']
        )
        expect(record_message.text).to eq(
          expected_record_message['texto']
        )
      end

      it 'parses plugin cheque_talao_sustado' do
        cheque_stopped = acerta_essencial.cheque_stopped
        expected_cheque_stopped = response.dig('essencial',
                                               'cheque_talao_sustado')

        expect(cheque_stopped).to be_truthy

        expect(cheque_stopped.register_type).to eq(
          expected_cheque_stopped['tipoRegistro']
        )
        expect(cheque_stopped.register_size).to eq(
          expected_cheque_stopped['tamanhoRegistro']
        )
        expect(cheque_stopped.register).to eq(
          expected_cheque_stopped['registro']
        )
        expect(cheque_stopped.occurrence_type).to eq(
          expected_cheque_stopped['tipoOcorrencia']
        )
        expect(cheque_stopped.document_type).to eq(
          expected_cheque_stopped['tipoDeDocumento']
        )
        expect(cheque_stopped.document_number).to eq(
          expected_cheque_stopped['numeroDocumento']
        )
        expect(cheque_stopped.bank).to eq(
          expected_cheque_stopped['banco']
        )
        expect(cheque_stopped.agency).to eq(
          expected_cheque_stopped['agencia']
        )
        expect(cheque_stopped.current_account).to eq(
          expected_cheque_stopped['contaCorrente']
        )
        expect(cheque_stopped.cheque).to eq(
          expected_cheque_stopped['cheque']
        )
        expect(cheque_stopped.point).to eq(
          expected_cheque_stopped['alinea']
        )
        expect(cheque_stopped.occurrence_date).to eq(
          expected_cheque_stopped['dataOcorrencia']
        )
        expect(cheque_stopped.availability_date).to eq(
          expected_cheque_stopped['dataDisponibilizacao']
        )
        expect(cheque_stopped.informant).to eq(
          expected_cheque_stopped['informante']
        )
        expect(cheque_stopped.indicator).to eq(
          expected_cheque_stopped['indicador']
        )
      end

      it 'parses plugin resumo_devolucoes_informadas_pelo_ccf' do
        # rubocop:disable Layout/LineLength
        summary_devolution_reported_by_ccf = acerta_essencial.summary_devolution_reported_by_ccf
        # rubocop:enable Layout/LineLength
        expected_summary_devolution_reported_by_ccf = response.dig(
          'essencial', 'resumo_devolucoes_informadas_pelo_ccf'
        )

        expect(summary_devolution_reported_by_ccf).to be_truthy

        expect(summary_devolution_reported_by_ccf.register_type).to eq(
          expected_summary_devolution_reported_by_ccf['tipoRegistro']
        )
        expect(summary_devolution_reported_by_ccf.register_size).to eq(
          expected_summary_devolution_reported_by_ccf['tamanhoRegistro']
        )
        expect(summary_devolution_reported_by_ccf.register).to eq(
          expected_summary_devolution_reported_by_ccf['registro']
        )
        expect(summary_devolution_reported_by_ccf.document_type).to eq(
          expected_summary_devolution_reported_by_ccf['tipoDocumento']
        )
        expect(summary_devolution_reported_by_ccf.document_number).to eq(
          expected_summary_devolution_reported_by_ccf['numeroDocumento']
        )
        expect(summary_devolution_reported_by_ccf.name).to eq(
          expected_summary_devolution_reported_by_ccf['nome']
        )
        expect(summary_devolution_reported_by_ccf.names_total).to eq(
          expected_summary_devolution_reported_by_ccf['totalNomes']
        )
        expect(summary_devolution_reported_by_ccf.devolution_total).to eq(
          expected_summary_devolution_reported_by_ccf['totalDevolucoes']
        )
        expect(summary_devolution_reported_by_ccf.reason_12).to eq(
          expected_summary_devolution_reported_by_ccf['motivo_12']
        )
        expect(summary_devolution_reported_by_ccf.reason_13).to eq(
          expected_summary_devolution_reported_by_ccf['motivo_13']
        )
        expect(summary_devolution_reported_by_ccf.reason_14).to eq(
          expected_summary_devolution_reported_by_ccf['motivo_14']
        )
        expect(summary_devolution_reported_by_ccf.reason_99).to eq(
          expected_summary_devolution_reported_by_ccf['motivo_99']
        )
      end

      it 'parses plugin resumo_consultas_anteriores_cheque' do
        # rubocop:disable Layout/LineLength
        summary_previous_query_cheque = acerta_essencial.summary_previous_query_cheque
        # rubocop:enable Layout/LineLength
        expected_summary_previous_query_cheque = response.dig(
          'essencial', 'resumo_consultas_anteriores_cheque'
        )

        expect(summary_previous_query_cheque).to be_truthy

        expect(summary_previous_query_cheque.register_size).to eq(
          expected_summary_previous_query_cheque['tamanhoRegistro']
        )
        expect(summary_previous_query_cheque.register_type).to eq(
          expected_summary_previous_query_cheque['tipoRegistro']
        )
        expect(summary_previous_query_cheque.register).to eq(
          expected_summary_previous_query_cheque['registro']
        )
        expect(summary_previous_query_cheque.document_type).to eq(
          expected_summary_previous_query_cheque['tipoDocumento']
        )
        expect(summary_previous_query_cheque.document_number).to eq(
          expected_summary_previous_query_cheque['numeroDocumento']
        )
        expect(summary_previous_query_cheque.total).to eq(
          expected_summary_previous_query_cheque['total']
        )
        expect(summary_previous_query_cheque.value).to eq(
          expected_summary_previous_query_cheque['valor']
        )
        expect(summary_previous_query_cheque.day).to eq(
          expected_summary_previous_query_cheque['dia']
        )
        expect(summary_previous_query_cheque.day_value).to eq(
          expected_summary_previous_query_cheque['valorDia']
        )
        expect(summary_previous_query_cheque.pre_dated).to eq(
          expected_summary_previous_query_cheque['preDatado']
        )
        expect(summary_previous_query_cheque.pre_dated_value).to eq(
          expected_summary_previous_query_cheque['valorPreDatado']
        )
      end

      it 'parses plugin confirmacao_telefone' do
        phone_confirmation = acerta_essencial.phone_confirmation
        expected_phone_confirmation = response.dig(
          'essencial', 'confirmacao_telefone'
        )

        expect(phone_confirmation).to be_truthy

        expect(phone_confirmation.register_size).to eq(
          expected_phone_confirmation['tamanhoRegistro']
        )
        expect(phone_confirmation.register_type).to eq(
          expected_phone_confirmation['tipoRegistro']
        )
        expect(phone_confirmation.register).to eq(
          expected_phone_confirmation['registro']
        )
        expect(phone_confirmation.area_code).to eq(
          expected_phone_confirmation['ddd']
        )
        expect(phone_confirmation.phone).to eq(
          expected_phone_confirmation['telefone']
        )
        expect(phone_confirmation.document_type).to eq(
          expected_phone_confirmation['tipoDocumento']
        )
        expect(phone_confirmation.document_number).to eq(
          expected_phone_confirmation['numeroDocumento']
        )
        expect(phone_confirmation.name).to eq(
          expected_phone_confirmation['nome']
        )
        expect(phone_confirmation.neighborhood).to eq(
          expected_phone_confirmation['bairro']
        )
        expect(phone_confirmation.zip_code).to eq(
          expected_phone_confirmation['cep']
        )
        expect(phone_confirmation.city).to eq(
          expected_phone_confirmation['cidade']
        )
        expect(phone_confirmation.federative_unit).to eq(
          expected_phone_confirmation['uf']
        )
      end

      it 'parses plugin endereco_telefones_agencia_bancaria' do
        bank_branch_phones_address = acerta_essencial.bank_branch_phones_address
        expected_bank_branch_phones_address = response.dig(
          'essencial', 'endereco_telefones_agencia_bancaria'
        )

        expect(bank_branch_phones_address).to be_truthy

        expect(bank_branch_phones_address.register_size).to eq(
          expected_bank_branch_phones_address['tamanhoRegistro']
        )
        expect(bank_branch_phones_address.register_type).to eq(
          expected_bank_branch_phones_address['tipoRegistro']
        )
        expect(bank_branch_phones_address.register).to eq(
          expected_bank_branch_phones_address['registro']
        )
        expect(bank_branch_phones_address.bank).to eq(
          expected_bank_branch_phones_address['banco']
        )
        expect(bank_branch_phones_address.bank_name).to eq(
          expected_bank_branch_phones_address['nomeBanco']
        )
        expect(bank_branch_phones_address.agency).to eq(
          expected_bank_branch_phones_address['agencia']
        )
        expect(bank_branch_phones_address.agency_name).to eq(
          expected_bank_branch_phones_address['nomeAgencia']
        )
        expect(bank_branch_phones_address.address).to eq(
          expected_bank_branch_phones_address['endereco']
        )
        expect(bank_branch_phones_address.neighborhood).to eq(
          expected_bank_branch_phones_address['bairro']
        )
        expect(bank_branch_phones_address.zip_code).to eq(
          expected_bank_branch_phones_address['cep']
        )
        expect(bank_branch_phones_address.city).to eq(
          expected_bank_branch_phones_address['cidade']
        )
        expect(bank_branch_phones_address.federative_unit).to eq(
          expected_bank_branch_phones_address['uf']
        )
        expect(bank_branch_phones_address.plaza).to eq(
          expected_bank_branch_phones_address['praca']
        )
        expect(bank_branch_phones_address.area_code).to eq(
          expected_bank_branch_phones_address['ddd']
        )
        expect(bank_branch_phones_address.phone_1).to eq(
          expected_bank_branch_phones_address['telefone_1']
        )
        expect(bank_branch_phones_address.phone_2).to eq(
          expected_bank_branch_phones_address['telefone_2']
        )
        expect(bank_branch_phones_address.reserved).to eq(
          expected_bank_branch_phones_address['reservado']
        )
      end
    end

    context 'when parse is called with missing data' do
      let(:cpf) { Faker::CPF.pretty }
      let(:boa_vista_response_path) do
        File.join(
          __dir__,
          '..',
          '..',
          '..',
          'fixtures',
          'boa_vista',
          'response_with_missing_data.xml'
        )
      end
      let(:response_xml) do
        Nokogiri::XML(File.open(boa_vista_response_path)).to_xml
      end
      let(:response) { Hash.from_xml(response_xml) }
      let(:credit_type) { 'CC' }
      let(:acerta_essencial) do
        DataLoaders::BoaVista::AcertaEssencial.parse(
          cpf, credit_type, response
        )
      end

      it 'creates the acerta_essencial correctly' do
        expect(acerta_essencial.cpf).to eq(cpf)
        expect(acerta_essencial.credit_type).to eq(credit_type)
      end
    end

    context 'when parse is called with nil data' do
      let(:cpf) { Faker::CPF.pretty }
      let(:credit_type) { 'CC' }
      let(:acerta_essencial) do
        DataLoaders::BoaVista::AcertaEssencial.parse(
          cpf, credit_type, nil
        )
      end

      it 'returns nil' do
        expect(acerta_essencial).to eq(nil)
      end
    end
  end
end
