# frozen_string_literal: true

module CustomParseable
  def parse(cpf, credit_type, data)
    return unless data.present?

    if data.dig('mensagem', 'codigo_erro')
      exception_handler(data['mensagem'])

      return
    end

    object = get_object(to_s)

    object.cpf = cpf
    object.credit_type = credit_type

    essencials = data['essencial']

    essencials&.keys&.each do |key|
      method_name = "parse_#{key}"
      if respond_to? method_name
        public_send(method_name, essencials,
                    object)
      end
    end

    object
  end

  def parse_resumoConsultas_anteriores_90_dias(essencials, object)
    previous90_days_consultation = essencials[
      'resumoConsultas_anteriores_90_dias'
    ]

    return object unless previous90_days_consultation

    register_size = previous90_days_consultation['tamanhoRegistro']
    register_type = previous90_days_consultation['tipoRegistro']
    register = previous90_days_consultation['registro']
    total = previous90_days_consultation['total']
    year_1 = previous90_days_consultation['ano_1']
    month_1 = previous90_days_consultation['mes_1']
    total_1 = previous90_days_consultation['total_1']
    year_2 = previous90_days_consultation['ano_2']
    month_2 = previous90_days_consultation['mes_2']
    total_2 = previous90_days_consultation['total_2']
    year_3 = previous90_days_consultation['ano_3']
    month_3 = previous90_days_consultation['mes_3']
    total_3 = previous90_days_consultation['total_3']
    year_4 = previous90_days_consultation['ano_4']
    month_4 = previous90_days_consultation['mes_4']
    total_4 = previous90_days_consultation['total_4']

    object.previous90_days_consultation = save_previous90_days_consultation(
      register_size, register_type, register, total, year_1, month_1,
      total_1, year_2, month_2, total_2, year_3, month_3, total_3,
      year_4, month_4, total_4
    )

    object
  end

  def parse_resumo_ocorrencias_de_debitos(essencials, object)
    debit_occurrence = essencials[
      'resumo_ocorrencias_de_debitos'
    ]

    register_size = debit_occurrence['tamanhoRegistro']
    register_type = debit_occurrence['tipoRegistro']
    register = debit_occurrence['registro']
    total_debtor = debit_occurrence['totalDevedor']
    total_guarantor = debit_occurrence['totalAvalista']
    accumulated_value = debit_occurrence['valorAcomulado']
    first_debit_date = debit_occurrence['dataPrimeiroDebito']
    first_debit_value = debit_occurrence['valorPrimeiroDebito']
    biggest_debit_date = debit_occurrence['dataMaiorDebito']
    biggest_debit_value = debit_occurrence['valorMaiorDebito']

    object.debit_occurrence = save_debit_occurrence(
      register_size, register_type, register, total_debtor, total_guarantor,
      accumulated_value, first_debit_date, first_debit_value,
      biggest_debit_date, biggest_debit_value
    )

    object
  end

  def parse_informacoes_complementares(essencials, object)
    additional_informations = [
      essencials['informacoes_complementares']
    ].flatten(1)

    return object unless additional_informations

    additional_informations.map! do |additional_information|
      register_size = additional_information['tamanhoRegistro']
      register_type = additional_information['tipoRegistro']
      register = additional_information['registro']
      text = additional_information['texto']
      origin = additional_information['origem']
      fu_origin = additional_information['ufOrigem']
      type = additional_information['tipo']

      save_additional_information(
        register_size, register_type, register, text, origin,
        fu_origin, type
      )
    end

    object.additional_informations = additional_informations

    object
  end

  def parse_debitos(essencials, object)
    debits = [essencials['debitos']].flatten(1)

    return object unless debits

    debits.map! do |debit|
      register_size = debit['tamanhoRegistro']
      register_type = debit['tipoRegistro']
      register = debit['registro']
      occurrence_type = debit['tipoOcorrencia']
      occurrence_date = debit['dataOcorrencia']
      contract = debit['contrato']
      availability_date = debit['dataDisponibilizacao']
      currency = debit['moeda']
      value = debit['valor']
      condition = debit['situacao']
      informant = debit['informante']
      informed_by_querent = debit['informadoPeloConsulente']
      segment = debit['segmento']

      return unless value.present?

      save_debit(
        register_size, register_type, register, occurrence_type,
        occurrence_date, contract, availability_date, currency, value,
        condition, informant, informed_by_querent, segment
      )
    end

    object.debits = debits

    object
  end

  def parse_titulos_protestados(essencials, object)
    protested_titles = [essencials['titulos_protestados']].flatten(1)

    return object unless protested_titles

    protested_titles.map! do |protested_title|
      register_size = protested_title['tamanhoRegistro']
      register_type = protested_title['tipoRegistro']
      register = protested_title['registro']
      occurrence_type = protested_title['tipoOcorrencia']
      registry = protested_title['cartorio']
      occurrence_date = protested_title['dataOcorrencia']
      currency = protested_title['moeda']
      value = protested_title['valor']
      city = protested_title['cidade']
      federative_unit = protested_title['uf']

      return unless value.present?

      save_protested_title(
        register_size, register_type, register, occurrence_type, registry,
        occurrence_date, currency, value, city, federative_unit
      )
    end

    object.protested_titles = protested_titles

    object
  end

  def parse_resumo_titulos_protestados(essencials, object)
    protested_title_summary = essencials['resumo_titulos_protestados']

    return object unless protested_title_summary

    register_size = protested_title_summary['tamanhoRegistro']
    register_type = protested_title_summary['tipoRegistro']
    register = protested_title_summary['registro']
    total = protested_title_summary['total']
    federative_unit = protested_title_summary['uf']
    initial_period = protested_title_summary['periodoInicial']
    final_period = protested_title_summary['periodoFinal']
    currency = protested_title_summary['moeda']
    accumulated_value = protested_title_summary['valorAcumulado']

    object.protested_title_summary = save_protested_title_summary(
      register_size, register_type, register, total, initial_period,
      final_period, currency, accumulated_value, federative_unit
    )

    object
  end

  def parse_cheque_talao_sustado(essencials, object)
    cheque_stopped = essencials['cheque_talao_sustado']

    return object unless cheque_stopped

    register_size = cheque_stopped['tamanhoRegistro']
    register_type = cheque_stopped['tipoRegistro']
    register = cheque_stopped['registro']
    occurrence_type = cheque_stopped['tipoOcorrencia']
    document_type = cheque_stopped['tipoDeDocumento']
    document_number = cheque_stopped['numeroDocumento']
    bank = cheque_stopped['banco']
    agency = cheque_stopped['agencia']
    current_account = cheque_stopped['contaCorrente']
    cheque = cheque_stopped['cheque']
    point = cheque_stopped['alinea']
    occurrence_date = cheque_stopped['dataOcorrencia']
    availability_date = cheque_stopped['dataDisponibilizacao']
    informant = cheque_stopped['informante']
    indicator = cheque_stopped['indicador']

    object.cheque_stopped = save_cheque_stopped(
      register_size, register_type, register, occurrence_type,
      document_type, document_number, bank, agency, current_account,
      cheque, point, occurrence_date, availability_date,
      informant, indicator
    )

    object
  end

  def parse_resumo_devolucoes_informadas_pelo_ccf(essencials, object)
    summary_devolution_reported_by_ccf = essencials[
      'resumo_devolucoes_informadas_pelo_ccf'
    ]

    return object unless summary_devolution_reported_by_ccf

    register_size = summary_devolution_reported_by_ccf['tamanhoRegistro']
    register_type = summary_devolution_reported_by_ccf['tipoRegistro']
    register = summary_devolution_reported_by_ccf['registro']
    document_type = summary_devolution_reported_by_ccf['tipoDocumento']
    document_number = summary_devolution_reported_by_ccf['numeroDocumento']
    name = summary_devolution_reported_by_ccf['nome']
    names_total = summary_devolution_reported_by_ccf['totalNomes']
    devolution_total = summary_devolution_reported_by_ccf['totalDevolucoes']
    reason_12 = summary_devolution_reported_by_ccf['motivo_12']
    reason_13 = summary_devolution_reported_by_ccf['motivo_13']
    reason_14 = summary_devolution_reported_by_ccf['motivo_14']
    reason_99 = summary_devolution_reported_by_ccf['motivo_99']

    object.summary_devolution_reported_by_ccf = save_summary_devolution_reported_by_ccf(
      register_size, register_type, register, document_type,
      document_number, name, names_total, devolution_total, reason_12,
      reason_13, reason_14, reason_99
    )

    object
  end

  def parse_resumo_consultas_anteriores_cheque(essencials, object)
    summary_previous_query_cheque = essencials['resumo_consultas_anteriores_cheque']

    return object unless summary_previous_query_cheque

    register_size = summary_previous_query_cheque['tamanhoRegistro']
    register_type = summary_previous_query_cheque['tipoRegistro']
    register = summary_previous_query_cheque['registro']
    document_type = summary_previous_query_cheque['tipoDocumento']
    document_number = summary_previous_query_cheque['numeroDocumento']
    total = summary_previous_query_cheque['total']
    value = summary_previous_query_cheque['valor']
    day = summary_previous_query_cheque['dia']
    day_value = summary_previous_query_cheque['valorDia']
    pre_dated = summary_previous_query_cheque['preDatado']
    pre_dated_value = summary_previous_query_cheque['valorPreDatado']

    object.summary_previous_query_cheque = save_summary_previous_query_cheque(
      register_size, register_type, register, document_type, document_number,
      total, value, day, day_value, pre_dated, pre_dated_value
    )

    object
  end

  def parse_confirmacao_telefone(essencials, object)
    phone_confirmation = essencials['confirmacao_telefone']

    return object unless phone_confirmation

    register_size = phone_confirmation['tamanhoRegistro']
    register_type = phone_confirmation['tipoRegistro']
    register = phone_confirmation['registro']
    area_code = phone_confirmation['ddd']
    phone = phone_confirmation['telefone']
    document_type = phone_confirmation['tipoDocumento']
    document_number = phone_confirmation['numeroDocumento']
    name = phone_confirmation['nome']
    neighborhood = phone_confirmation['bairro']
    zip_code = phone_confirmation['cep']
    city = phone_confirmation['cidade']
    federative_unit = phone_confirmation['uf']

    object.phone_confirmation = save_phone_confirmation(
      register_size, register_type, register, area_code, phone,
      document_type, document_number, name, neighborhood, zip_code, city,
      federative_unit
    )

    object
  end

  def parse_endereco_telefones_agencia_bancaria(essencials, object)
    bank_branch_phones_address = essencials['endereco_telefones_agencia_bancaria']

    return object unless bank_branch_phones_address

    register_size = bank_branch_phones_address['tamanhoRegistro']
    register_type = bank_branch_phones_address['tipoRegistro']
    register = bank_branch_phones_address['registro']
    bank = bank_branch_phones_address['banco']
    bank_name = bank_branch_phones_address['nomeBanco']
    agency = bank_branch_phones_address['agencia']
    agency_name = bank_branch_phones_address['nomeAgencia']
    address = bank_branch_phones_address['endereco']
    neighborhood = bank_branch_phones_address['bairro']
    zip_code = bank_branch_phones_address['cep']
    city = bank_branch_phones_address['cidade']
    federative_unit = bank_branch_phones_address['uf']
    plaza = bank_branch_phones_address['praca']
    area_code = bank_branch_phones_address['ddd']
    phone_1 = bank_branch_phones_address['telefone_1']
    phone_2 = bank_branch_phones_address['telefone_2']
    reserved = bank_branch_phones_address['reservado']

    object.bank_branch_phones_address = save_bank_branch_phones_address(
      register_size, register_type, register, bank, bank_name, agency,
      agency_name, address, neighborhood, zip_code, city, federative_unit,
      plaza, area_code, phone_1, phone_2, reserved
    )

    object
  end

  def parse_confirmacao_cep(essencials, object)
    zip_code_confirmation = essencials['confirmacao_cep']

    return object unless zip_code_confirmation

    register_size = zip_code_confirmation['tamanhoRegistro']
    register_type = zip_code_confirmation['tipoRegistro']
    register = zip_code_confirmation['registro']
    zip_code = zip_code_confirmation['cep']
    address = zip_code_confirmation['endereco']
    neighborhood = zip_code_confirmation['bairro']
    city = zip_code_confirmation['cidade']
    federative_unit = zip_code_confirmation['uf']

    object.zip_code_confirmation = save_zip_code_confirmation(
      register_size, register_type, register, zip_code, address,
      neighborhood, city, federative_unit
    )

    object
  end

  def parse_nome_documentos(essencials, object)
    documents_name = essencials['nome_documentos']

    return object unless documents_name

    register_size = documents_name['tamanhoRegistro']
    register_type = documents_name['tipoRegistro']
    register = documents_name['registro']
    name = documents_name['nome']
    birth_date = documents_name['nascimento']
    document_type = documents_name['tipoDocumento']
    document_number = documents_name['numeroDocumento']
    document_2 = documents_name['documento_2']
    document_3 = documents_name['documento_3']

    object.documents_name = save_documents_name(
      register_size, register_type, register, name, birth_date, document_type,
      document_number, document_2, document_3
    )

    object
  end

  def parse_relacao_devolucoes_informadas_pelo_ccf(essencials, object)
    list_of_returns_reported_by_ccfs = [
      essencials['relacao_devolucoes_informadas_pelo_ccf']
    ].flatten(1)

    return object unless list_of_returns_reported_by_ccfs

    list_of_returns_reported_by_ccfs.map! do |list_of_returns_reported_by_ccf|
      register_size = list_of_returns_reported_by_ccf.dig 'tamanhoRegistro'
      register_type = list_of_returns_reported_by_ccf.dig 'tipoRegistro'
      register = list_of_returns_reported_by_ccf.dig 'registro'
      document_type = list_of_returns_reported_by_ccf.dig 'tipoDocumento'
      document_number = list_of_returns_reported_by_ccf.dig 'numeroDocumento'
      name = list_of_returns_reported_by_ccf.dig 'nome'
      bank = list_of_returns_reported_by_ccf.dig 'banco'
      agency = list_of_returns_reported_by_ccf.dig 'agencia'
      reason_12 = list_of_returns_reported_by_ccf.dig 'motivo_12'
      last_occurrence_12_date = list_of_returns_reported_by_ccf.dig(
        'data_ultima_ocorrencia_12'
      )
      reason_13 = list_of_returns_reported_by_ccf.dig 'motivo_13'
      last_occurrence_13_date = list_of_returns_reported_by_ccf.dig(
        'data_ultima_ocorrencia_13'
      )
      reason_14 = list_of_returns_reported_by_ccf.dig 'motivo_14'
      last_occurrence_14_date = list_of_returns_reported_by_ccf.dig(
        'data_ultima_ocorrencia_14'
      )
      reason_99 = list_of_returns_reported_by_ccf.dig 'motivo_99'
      last_occurrence_99_date = list_of_returns_reported_by_ccf.dig(
        'data_ultima_ocorrencia_99'
      )
      bank_name = list_of_returns_reported_by_ccf.dig 'nomeBanco'

      save_list_of_returns_reported_by_ccf(
        register_size, register_type, register, document_type, document_number,
        name, bank, agency, reason_12, last_occurrence_12_date, reason_13,
        last_occurrence_13_date, reason_14, last_occurrence_14_date, reason_99,
        last_occurrence_99_date, bank_name
      )
    end

    object.list_of_returns_reported_by_ccfs = list_of_returns_reported_by_ccfs

    object
  end

  def parse_informacoes_complementares_cheque(essencials, object)
    cheque_additional_information = essencials['informacoes_complementares_cheque']

    return object unless cheque_additional_information

    register_size = cheque_additional_information['tamanhoRegistro']
    register_type = cheque_additional_information['tipoRegistro']
    register = cheque_additional_information['registro']
    document_type = cheque_additional_information['tipoDocumento']
    document_number = cheque_additional_information['numeroDocumento']
    text = cheque_additional_information['texto']
    type_of_register = cheque_additional_information['tipoDoRegistro']

    object.cheque_additional_information = save_cheque_additional_information(
      register_size, register_type, register, document_type,
      document_number, text, type_of_register
    )

    object
  end

  def parse_devolucoes_informadas_pelo_usuario(essencials, object)
    returns_reported_by_user = essencials['devolucoes_informadas_pelo_usuario']

    return object unless returns_reported_by_user

    register_size = returns_reported_by_user['tamanhoRegistro']
    register_type = returns_reported_by_user['tipoRegistro']
    register = returns_reported_by_user['registro']
    document_type = returns_reported_by_user['tipoDocumento']
    document = returns_reported_by_user['documento']
    bank = returns_reported_by_user['banco']
    agency = returns_reported_by_user['agencia']
    current_account = returns_reported_by_user['contaCorrente']
    initial_cheque = returns_reported_by_user['chequeInicial']
    final_cheque = returns_reported_by_user['chequeFinal']
    reason = returns_reported_by_user['motivo']
    point = returns_reported_by_user['alinea']
    occurrence_date = returns_reported_by_user['dataOcorrencia']
    register_date = returns_reported_by_user['dataRegistro']
    currency = returns_reported_by_user['moeda']
    value = returns_reported_by_user['valor']
    informant_code = returns_reported_by_user['codigoInformante']
    informant = returns_reported_by_user['informante']
    city = returns_reported_by_user['cidade']
    federative_unit = returns_reported_by_user['uf']

    object.returns_reported_by_user = save_returns_reported_by_user(
      register_size, register_type, register, document_type, document,
      bank, agency, current_account, initial_cheque, final_cheque, reason,
      point, occurrence_date, register_date, currency, value, informant_code,
      informant, city, federative_unit
    )

    object
  end

  def parse_cheques_sustados_pelo_motivo_21(essencials, object)
    cheques_stopped_for_reason21 = essencials['cheques_sustados_pelo_motivo_21']

    return object unless cheques_stopped_for_reason21

    register_size = cheques_stopped_for_reason21['tamanhoRegistro']
    register_type = cheques_stopped_for_reason21['tipoRegistro']
    register = cheques_stopped_for_reason21['registro']
    document_type = cheques_stopped_for_reason21['tipoDocumento']
    document_number = cheques_stopped_for_reason21['numeroDocumento']
    bank = cheques_stopped_for_reason21['banco']
    agency = cheques_stopped_for_reason21['agencia']
    current_account = cheques_stopped_for_reason21['contaCorrente']
    initial_cheque = cheques_stopped_for_reason21['chequeInicial']
    final_cheque = cheques_stopped_for_reason21['chequeFinal']
    point = cheques_stopped_for_reason21['alinea']
    occurrence_date = cheques_stopped_for_reason21['dataOcorrencia']
    availability_date = cheques_stopped_for_reason21['dataDisponibilizacao']
    currency = cheques_stopped_for_reason21['moeda']
    value = cheques_stopped_for_reason21['valor']
    informant = cheques_stopped_for_reason21['informante']

    object.cheques_stopped_for_reason21 = save_cheques_stopped_for_reason21(
      register_size, register_type, register, document_type, document_number,
      bank, agency, current_account, initial_cheque, final_cheque, point,
      occurrence_date, availability_date, currency, value, informant
    )

    object
  end

  def parse_historico_cheque_informado(essencials, object)
    historic_informed_cheque = essencials['historico_cheque_informado']

    return object unless historic_informed_cheque

    register_size = historic_informed_cheque['tamanhoRegistro']
    register_type = historic_informed_cheque['tipoRegistro']
    register = historic_informed_cheque['registro']
    document_type = historic_informed_cheque['tipoDocumento']
    document_number = historic_informed_cheque['numeroDocumento']
    bank = historic_informed_cheque['banco']
    agency = historic_informed_cheque['agencia']
    current_account = historic_informed_cheque['contaCorrente']
    cheque = historic_informed_cheque['cheque']
    consultation_date = historic_informed_cheque['dataConsulta']
    consultation_hour = historic_informed_cheque['horaConsulta']
    network = historic_informed_cheque['rede']

    object.historic_informed_cheque = save_historic_informed_cheque(
      register_size, register_type, register, document_type, document_number,
      bank, agency, current_account, cheque, consultation_date,
      consultation_hour, network
    )

    object
  end

  def parse_historico_conta_corrente_informada(essencials, object)
    current_account_historic = essencials['historico_conta_corrente_informada']

    return object unless current_account_historic

    register_size = current_account_historic['tamanhoRegistro']
    register_type = current_account_historic['tipoRegistro']
    register = current_account_historic['registro']
    bank = current_account_historic['banco']
    agency = current_account_historic['agencia']
    current_account = current_account_historic['contaCorrente']
    document_type = current_account_historic['tipoDocumento']
    document_number = current_account_historic['numeroDocumento']
    consultation_date = current_account_historic['dataConsulta']
    consultation_hour = current_account_historic['horaConsulta']

    object.current_account_historic = save_current_account_historic(
      register_size, register_type, register, bank, agency, current_account,
      document_type, document_number, consultation_date, consultation_hour
    )

    object
  end

  def parse_consultas_anteriores_cheque(essencials, object)
    previous_cheque_consultations = essencials[
      'consultas_anteriores_cheque'
    ]

    return object unless previous_cheque_consultations

    register_size = previous_cheque_consultations['tamanhoRegistro']
    register_type = previous_cheque_consultations['tipoRegistro']
    register = previous_cheque_consultations['registro']
    document_type = previous_cheque_consultations['tipoDocumento']
    document_number = previous_cheque_consultations['numeroDocumento']
    consultation_type = previous_cheque_consultations['tipo']
    credit_date = previous_cheque_consultations['dataCredito']
    credit_hour = previous_cheque_consultations['horaCredito']
    currency = previous_cheque_consultations['moeda']
    value = previous_cheque_consultations['valor']
    informant = previous_cheque_consultations['informante']

    object.previous_cheque_consultation = save_previous_cheque_consultation(
      register_size, register_type, register, document_type, document_number,
      consultation_type, credit_date, credit_hour, currency,
      value, informant
    )

    object
  end

  def parse_resumo_devolucoes_informada_pelo_usuario(essencials, object)
    summary_of_returns_reported_by_user = essencials[
      'resumo_devolucoes_informada_pelo_usuario'
    ]

    return object unless summary_of_returns_reported_by_user

    register_size = summary_of_returns_reported_by_user['tamanhoRegistro']
    register_type = summary_of_returns_reported_by_user['tipoRegistro']
    register = summary_of_returns_reported_by_user['registro']
    document_type = summary_of_returns_reported_by_user['tipoDocumento']
    document_number = summary_of_returns_reported_by_user['numeroDocumento']
    total = summary_of_returns_reported_by_user['total']
    first_devolution_date = summary_of_returns_reported_by_user['dataPrimeiraDevolucao']
    last_devolution_date = summary_of_returns_reported_by_user['dataUltimaDevolucao']

    object.summary_of_returns_reported_by_user = save_summary_of_returns_reported_by_user(
      register_size, register_type, register, document_type,
      document_number, total, first_devolution_date, last_devolution_date
    )

    object
  end

  def parse_identificacao(essencials, object)
    identification = essencials['identificacao']

    return object unless identification

    register_size = identification['tamanhoRegistro']
    register = identification['registro']
    document = identification['documento']
    name = identification['nome']
    mother_name = identification['nomeMae']
    birth_date = identification['dataNascimento']
    rg_number = identification['numeroRG']
    emitting_organ = identification['orgaoEmissor']
    rg_federative_unit = identification['unidadeFedarativaRG']
    rg_emitting_date = identification['dataEmissaoRG']
    consulted_gender = identification['sexoConsultado']
    birth_city = identification['cidadeNascimento']
    marital_status = identification['estadoCivil']
    dependent_number = identification['numeroDependentes']
    educational_level = identification['grauInstrucao']
    revenue_situation = identification['situacaoReceita']
    update_date = identification['dataAtualizacao']
    cpf_zone = identification['regiaoCpf']
    voter_title = identification['tituloEleitor']
    death = identification['obito']

    object.identification = save_identification(
      register_size, register, document, name, mother_name, birth_date,
      rg_number, emitting_organ, rg_federative_unit, rg_emitting_date,
      consulted_gender, birth_city, marital_status, dependent_number,
      educational_level, revenue_situation, update_date, cpf_zone,
      voter_title, death
    )

    object
  end

  def parse_localizacao(essencials, object)
    location = essencials['localizacao']

    return object unless location

    register_size = location['tamanhoRegistro']
    register_type = location['tipoRegistro']
    register = location['registro']
    public_place_type = location['tipoLogradouro']
    public_place_name = location['nomeLogradouro']
    public_place_number = location['numeroLogradouro']
    complement = location['complemento']
    neighborhood = location['bairro']
    city = location['cidade']
    federative_unit = location['unidadeFederativa']
    zip_code = location['cep']
    ddd_1 = location['ddd_1']
    phone_1 = location['telefone_1']
    ddd_2 = location['ddd_2']
    phone_2 = location['telefone_2']
    ddd_3 = location['ddd_3']
    phone_3 = location['telefone_3']

    object.location = save_location(
      register_size, register_type, register, public_place_type,
      public_place_name, public_place_number, complement, neighborhood,
      city, federative_unit, zip_code, ddd_1, phone_1, ddd_2, phone_2,
      ddd_3, phone_3
    )

    object
  end

  def parse_score_classificacao_varios_modelos(essencials, object)
    score_rating_several_models = [essencials[
      'score_classificacao_varios_modelos'
    ]].flatten(1)

    return object unless score_rating_several_models

    score_rating_several_models.map! do |score_rating_several_model|
      register_size = score_rating_several_model['tamanhoRegistro']
      register_type = score_rating_several_model['tipoRegistro']
      register = score_rating_several_model['registro']
      score_type = score_rating_several_model['tipoScore']
      score = score_rating_several_model['score']
      plan_name = score_rating_several_model['nomePlano']
      score_model = score_rating_several_model['modeloScore']
      score_name = score_rating_several_model['nomeScore']
      numeric_classification = score_rating_several_model['classificacaoNumerica']
      alphabetic_classification = score_rating_several_model['classificacaoAlfabetica']
      probability = score_rating_several_model['probabilidade']
      text = score_rating_several_model['texto']
      code_kind_model = score_rating_several_model['codigoNaturezaModelo']
      kind_description = score_rating_several_model['descricaoNatureza']
      text_2 = score_rating_several_model['texto2']
      value = score_rating_several_model['value']
      message = score_rating_several_model['message']

      save_score_rating_several_model(
        register_size, register_type, register, score_type, score, plan_name,
        score_model, score_name, numeric_classification,
        alphabetic_classification, probability, text, code_kind_model,
        kind_description, text_2, value, message
      )
    end

    object.score_rating_several_models = score_rating_several_models

    object
  end

  def parse_decisao(essencials, object)
    decision = essencials['decisao']

    return object unless decision

    register_size = decision['tamanhoRegistro']
    register_type = decision['tipoRegistro']
    register = decision['registro']
    document_type = decision['tipoDocumento']
    document = decision['documento']
    score = decision['score']
    approves = decision['aprova']
    text = decision['texto']

    object.decision = save_decision(
      register_size, register_type, register, document_type, document,
      score, approves, text
    )

    object
  end

  def parse_mensagem_registro(essencials, object)
    record_message = essencials['mensagem_registro']

    return object unless record_message

    register_size = record_message['tamanhoRegistro']
    register_type = record_message['tipoRegistro']
    register = record_message['registro']
    record_reference = record_message['registroReferencia']
    text = record_message['texto']

    object.record_message = save_record_message(
      register_size, register_type, register, record_reference, text
    )
  end

  def parse_cartao_credito_cheque_especial_e_outros_rotativos(commitment_score)
    credit_card_overdraft_and_other_revolving = save_credit_card_overdraft_and_other_revolving
    control_panel_items = [commitment_score['cartao_credito_cheque_especial_e_outros_rotativos'][
      'item_painel_controle'
    ]].flatten(1)

    return credit_card_overdraft_and_other_revolving unless control_panel_items

    control_panel_items.map! do |item|
      description = item['descricao']
      value = item['valor']

      save_control_panel_item(description, value)
    end

    credit_card_overdraft_and_other_revolving.control_panel_items = control_panel_items

    credit_card_overdraft_and_other_revolving
  end

  def save_current_account_historic(
    register_size, register_type, register, bank, agency, current_account,
    document_type, document_number, consultation_date, consultation_hour
  )
    BoaVista::CurrentAccountHistoric.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        bank: bank,
        agency: agency,
        current_account: current_account,
        document_type: document_type,
        document_number: document_number,
        consultation_date: consultation_date,
        consultation_hour: consultation_hour
      }
    )
  end

  def save_previous90_days_consultation(
    register_size, register_type, register, total, year_1, month_1,
    total_1, year_2, month_2, total_2, year_3, month_3, total_3,
    year_4, month_4, total_4
  )
    BoaVista::Previous90DaysConsultation.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        total: total,
        year_1: year_1,
        month_1: month_1,
        total_1: total_1,
        year_2: year_2,
        month_2: month_2,
        total_2: total_2,
        year_3: year_3,
        month_3: month_3,
        total_3: total_3,
        year_4: year_4,
        month_4: month_4,
        total_4: total_4
      }
    )
  end

  def save_identification(
    register_size, register, document, name, mother_name, birth_date, rg_number,
    emitting_organ, rg_federative_unit, rg_emitting_date, consulted_gender,
    birth_city, marital_status, dependent_number, educational_level,
    revenue_situation, update_date, cpf_zone, voter_title, death
  )
    BoaVista::Identification.new(
      {
        register_size: register_size,
        register: register,
        document: document,
        name: name,
        mother_name: mother_name,
        birth_date: birth_date,
        rg_number: rg_number,
        emitting_organ: emitting_organ,
        rg_federative_unit: rg_federative_unit,
        rg_emitting_date: rg_emitting_date,
        consulted_gender: consulted_gender,
        birth_city: birth_city,
        marital_status: marital_status,
        dependent_number: dependent_number,
        educational_level: educational_level,
        revenue_situation: revenue_situation,
        update_date: update_date,
        cpf_zone: cpf_zone,
        voter_title: voter_title,
        death: death
      }
    )
  end

  def save_debit_occurrence(
    register_size, register_type, register, total_debtor, total_guarantor,
    accumulated_value, first_debit_date, first_debit_value,
    biggest_debit_date, biggest_debit_value
  )
    BoaVista::DebitOccurrence.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        total_debtor: total_debtor,
        total_guarantor: total_guarantor,
        accumulated_value: accumulated_value,
        first_debit_date: first_debit_date,
        first_debit_value: first_debit_value,
        biggest_debit_date: biggest_debit_date,
        biggest_debit_value: biggest_debit_value
      }
    )
  end

  def save_additional_information(
    register_size, register_type, register, text, origin, fu_origin, type
  )
    BoaVista::AdditionalInformation.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        text: text,
        origin: origin,
        fu_origin: fu_origin,
        information_type: type
      }
    )
  end

  def save_debit(
    register_size, register_type, register, occurrence_type,
    occurrence_date, contract, availability_date, currency, value,
    condition, informant, informed_by_querent, segment
  )
    BoaVista::Debit.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        occurrence_type: occurrence_type,
        occurrence_date: occurrence_date,
        contract: contract,
        availability_date: availability_date,
        currency: currency,
        value: value,
        condition: condition,
        informant: informant,
        informed_by_querent: informed_by_querent,
        segment: segment
      }
    )
  end

  def save_cheque_stopped(
    register_size, register_type, register, occurrence_type, document_type,
    document_number, bank, agency, current_account, cheque, point,
    occurrence_date, availability_date, informant, indicator
  )
    BoaVista::ChequeStopped.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        occurrence_type: occurrence_type,
        document_type: document_type,
        document_number: document_number,
        bank: bank,
        agency: agency,
        current_account: current_account,
        cheque: cheque,
        point: point,
        occurrence_date: occurrence_date,
        availability_date: availability_date,
        informant: informant,
        indicator: indicator
      }
    )
  end

  def save_protested_title(
    register_size, register_type, register, occurrence_type, registry,
    occurrence_date, currency, value, city, federative_unit
  )
    BoaVista::ProtestedTitle.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        occurrence_type: occurrence_type,
        registry: registry,
        occurrence_date: occurrence_date,
        currency: currency,
        value: value,
        city: city,
        federative_unit: federative_unit
      }
    )
  end

  def save_protested_title_summary(
    register_size, register_type, register, total, initial_period,
    final_period, currency, accumulated_value, federative_unit
  )
    BoaVista::ProtestedTitleSummary.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        total: total,
        initial_period: initial_period,
        final_period: final_period,
        currency: currency,
        accumulated_value: accumulated_value,
        federative_unit: federative_unit
      }
    )
  end

  def save_phone_confirmation(
    register_size, register_type, register, area_code, phone,
    document_type, document_number, name, neighborhood, zip_code, city,
    federative_unit
  )
    BoaVista::PhoneConfirmation.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        area_code: area_code,
        phone: phone,
        document_type: document_type,
        document_number: document_number,
        name: name,
        neighborhood: neighborhood,
        zip_code: zip_code,
        city: city,
        federative_unit: federative_unit
      }
    )
  end

  def save_bank_branch_phones_address(
    register_size, register_type, register, bank, bank_name, agency,
    agency_name, address, neighborhood, zip_code, city, federative_unit,
    plaza, area_code, phone_1, phone_2, reserved
  )
    BoaVista::BankBranchPhonesAddress.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        bank: bank,
        bank_name: bank_name,
        agency: agency,
        agency_name: agency_name,
        address: address,
        neighborhood: neighborhood,
        zip_code: zip_code,
        city: city,
        federative_unit: federative_unit,
        plaza: plaza,
        area_code: area_code,
        phone_1: phone_1,
        phone_2: phone_2,
        reserved: reserved
      }
    )
  end

  def save_decision(
    register_size, register_type, register, document_type, document,
    score, approves, text
  )
    BoaVista::Decision.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        document_type: document_type,
        document: document,
        score: score,
        approves: approves,
        text: text
      }
    )
  end

  def save_location(
    register_size, register_type, register, public_place_type,
    public_place_name, public_place_number, complement, neighborhood,
    city, federative_unit, zip_code, ddd_1, phone_1, ddd_2, phone_2,
    ddd_3, phone_3
  )
    BoaVista::Location.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        public_place_type: public_place_type,
        public_place_name: public_place_name,
        public_place_number: public_place_number,
        complement: complement,
        neighborhood: neighborhood,
        city: city,
        federative_unit: federative_unit,
        zip_code: zip_code,
        ddd_1: ddd_1,
        phone_1: phone_1,
        ddd_2: ddd_2,
        phone_2: phone_2,
        ddd_3: ddd_3,
        phone_3: phone_3
      }
    )
  end

  def save_cheque_additional_information(
    register_size, register_type, register, document_type,
    document_number, text, type_of_register
  )
    BoaVista::ChequeAdditionalInformation.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        document_type: document_type,
        document_number: document_number,
        text: text,
        type_of_register: type_of_register
      }
    )
  end

  def save_zip_code_confirmation(
    register_size, register_type, register, zip_code, address,
    neighborhood, city, federative_unit
  )
    BoaVista::ZipCodeConfirmation.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        zip_code: zip_code,
        address: address,
        neighborhood: neighborhood,
        city: city,
        federative_unit: federative_unit
      }
    )
  end

  def save_documents_name(
    register_size, register_type, register, name, birth_date, document_type,
    document_number, document_2, document_3
  )
    BoaVista::DocumentsName.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        name: name,
        birth_date: birth_date,
        document_type: document_type,
        document_number: document_number,
        document_2: document_2,
        document_3: document_3
      }
    )
  end

  def save_list_of_returns_reported_by_ccf(
    register_size, register_type, register, document_type, document_number,
    name, bank, agency, reason_12, last_occurrence_12_date, reason_13,
    last_occurrence_13_date, reason_14, last_occurrence_14_date, reason_99,
    last_occurrence_99_date, bank_name
  )
    BoaVista::ListOfReturnsReportedByCcf.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        document_type: document_type,
        document_number: document_number,
        name: name,
        bank: bank,
        agency: agency,
        reason_12: reason_12,
        last_occurrence_12_date: last_occurrence_12_date,
        reason_13: reason_13,
        last_occurrence_13_date: last_occurrence_13_date,
        reason_14: reason_14,
        last_occurrence_14_date: last_occurrence_14_date,
        reason_99: reason_99,
        last_occurrence_99_date: last_occurrence_99_date,
        bank_name: bank_name
      }
    )
  end

  def save_summary_previous_query_cheque(
    register_size, register_type, register, document_type, document_number,
    total, value, day, day_value, pre_dated, pre_dated_value
  )
    BoaVista::SummaryPreviousQueryCheque.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        document_type: document_type,
        document_number: document_number,
        total: total,
        value: value,
        day: day,
        day_value: day_value,
        pre_dated: pre_dated,
        pre_dated_value: pre_dated_value
      }
    )
  end

  def save_summary_devolution_reported_by_ccf(
    register_size, register_type, register, document_type,
    document_number, name, names_total, devolution_total, reason_12,
    reason_13, reason_14, reason_99
  )
    BoaVista::SummaryDevolutionReportedByCcf.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        document_type: document_type,
        document_number: document_number,
        name: name,
        names_total: names_total,
        devolution_total: devolution_total,
        reason_12: reason_12,
        reason_13: reason_13,
        reason_14: reason_14,
        reason_99: reason_99
      }
    )
  end

  def save_returns_reported_by_user(
    register_size, register_type, register, document_type, document,
    bank, agency, current_account, initial_cheque, final_cheque, reason,
    point, occurrence_date, register_date, currency, value, informant_code,
    informant, city, federative_unit
  )
    BoaVista::ReturnsReportedByUser.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        document_type: document_type,
        document: document,
        bank: bank,
        agency: agency,
        current_account: current_account,
        initial_cheque: initial_cheque,
        final_cheque: final_cheque,
        reason: reason,
        point: point,
        occurrence_date: occurrence_date,
        register_date: register_date,
        currency: currency,
        value: value,
        informant_code: informant_code,
        informant: informant,
        city: city,
        federative_unit: federative_unit
      }
    )
  end

  def save_cheques_stopped_for_reason21(
    register_size, register_type, register, document_type, document_number,
    bank, agency, current_account, initial_cheque, final_cheque, point,
    occurrence_date, availability_date, currency, value, informant
  )
    BoaVista::ChequesStoppedForReason21.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        document_type: document_type,
        document_number: document_number,
        bank: bank,
        agency: agency,
        current_account: current_account,
        initial_cheque: initial_cheque,
        final_cheque: final_cheque,
        point: point,
        occurrence_date: occurrence_date,
        availability_date: availability_date,
        currency: currency,
        value: value,
        informant: informant
      }
    )
  end

  def save_historic_informed_cheque(
    register_size, register_type, register, document_type, document_number,
    bank, agency, current_account, cheque, consultation_date,
    consultation_hour, network
  )
    BoaVista::HistoricInformedCheque.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        document_type: document_type,
        document_number: document_number,
        bank: bank,
        agency: agency,
        current_account: current_account,
        cheque: cheque,
        consultation_date: consultation_date,
        consultation_hour: consultation_hour,
        network: network
      }
    )
  end

  def save_previous_cheque_consultation(
    register_size, register_type, register, document_type, document_number,
    consultation_type, credit_date, credit_hour, currency, value, informant
  )
    BoaVista::PreviousChequeConsultation.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        document_type: document_type,
        document_number: document_number,
        consultation_type: consultation_type,
        credit_date: credit_date,
        credit_hour: credit_hour,
        currency: currency,
        value: value,
        informant: informant
      }
    )
  end

  def save_summary_of_returns_reported_by_user(
    register_size, register_type, register, document_type,
    document_number, total, first_devolution_date, last_devolution_date
  )
    BoaVista::SummaryOfReturnsReportedByUser.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        document_type: document_type,
        document_number: document_number,
        total: total,
        first_devolution_date: first_devolution_date,
        last_devolution_date: last_devolution_date
      }
    )
  end

  def save_score_rating_several_model(
    register_size, register_type, register, score_type, score, plan_name,
    score_model, score_name, numeric_classification,
    alphabetic_classification, probability, text, code_kind_model,
    kind_description, text_2, value, message
  )
    BoaVista::ScoreRatingSeveralModel.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        score_type: score_type,
        score: score,
        plan_name: plan_name,
        score_model: score_model,
        score_name: score_name,
        numeric_classification: numeric_classification,
        alphabetic_classification: alphabetic_classification,
        probability: probability,
        text: text,
        code_kind_model: code_kind_model,
        kind_description: kind_description,
        text_2: text_2,
        value: value,
        message: message
      }
    )
  end

  def save_record_message(
    register_size, register_type, register, record_reference, text
  )
    BoaVista::RecordMessage.new(
      {
        register_size: register_size,
        register_type: register_type,
        register: register,
        record_reference: record_reference,
        text: text
      }
    )
  end

  def exception_handler(message)
    error_code = message['codigo_erro']
    error_message = message['mensagem_erro']

    raise StandardError, "
            BoaVista::Base exception code #{error_code}:
            #{error_message}
          "
  end

  def get_object(klass)
    acerta_essencial_integrator = klass.split('::').last

    acerta_essencial_and_hex = acerta_essencial_integrator.gsub('Integrator',
                                                                '')

    acerta_essencial = acerta_essencial_and_hex.split(':').first

    Object.const_get("BoaVista::#{acerta_essencial}").new
  end
end
