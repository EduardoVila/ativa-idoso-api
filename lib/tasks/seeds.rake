# frozen_string_literal: true

namespace :db do
  desc 'Populates database: default seed quantity is set to 1; ' \
       'to alter quantity, use: seeds:populate QTY=<integer>'
  task populate: :environment do
    require_relative '../../config/environments' # Environment setup
    require_relative '../../config/application' # Application setup
    require 'colorize'

    quantity = ENV['QTY'] || 1
    quantity.to_i.times do
      api_client = API::Client.create!

      # Analysis module
      analysis_report = Analysis::Report.create!(
        {
          cpfs: [Faker::CPF.pretty, Faker::CPF.pretty],
          status: :done,
          fee: 8.5,
          approved: true,
          api_client_id: api_client.id
        }
      )

      analysis_item = Analysis::Item.create!(
        {
          cpf: Faker::CPF.pretty,
          error_status: :none,
          analysis_report_id: analysis_report.id
        }
      )

      Analysis::Prediction.create!(
        {
          label: 'human_analyzed',
          approved: true,
          fee: [6.5, 7.5, 8.5, 9.5, 10.5, 12].sample,
          analysis_item_id: analysis_item.id
        }
      )

      # BoaVista module
      acerta_essencial = BoaVista::AcertaEssencial.create!(
        {
          cpf: Faker::CPF.pretty,
          credit_type: :CC,
          raw_data: '{}',
          consumer_id: analysis_item.id,
          consumer_type: 'Analysis::Item'
        }
      )

      BoaVista::AdditionalInformation.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          text: Faker::Lorem.sentence,
          origin: Faker::Lorem.word,
          fu_origin: Faker::Address.state_abbr,
          information_type: Faker::Lorem.word,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::Debit.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          occurrence_type: Faker::Lorem.word,
          occurrence_date: Faker::Date.backward.to_s,
          contract: Faker::Lorem.word,
          availability_date: Faker::Date.forward.to_s,
          currency: '0',
          value: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s,
          condition: Faker::Lorem.word,
          informant: Faker::Lorem.word,
          segment: Faker::Lorem.word,
          informed_by_querent: Faker::Lorem.word,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::ProtestedTitle.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          occurrence_type: Faker::Lorem.word,
          registry: Faker::Lorem.word,
          occurrence_date: Faker::Date.backward.to_s,
          currency: '0',
          value: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s,
          city: Faker::Address.city,
          federative_unit: Faker::Address.state_abbr,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::ProtestedTitleSummary.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          total: Faker::Number.number(digits: 3).to_s,
          initial_period: Faker::Date.backward.to_s,
          final_period: Faker::Date.forward.to_s,
          currency: '0',
          accumulated_value: Faker::Number.decimal(l_digits: 3,
                                                   r_digits: 2).to_s,
          federative_unit: Faker::Address.state_abbr,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::Identification.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register: Faker::Lorem.word,
          document: Faker::Lorem.word,
          name: Faker::Name.name,
          mother_name: Faker::Name.name,
          birth_date: Faker::Date.backward.to_s,
          rg_number: Faker::Number.number(digits: 9).to_s,
          emitting_organ: Faker::Lorem.word,
          rg_federative_unit: Faker::Address.state_abbr,
          rg_emitting_date: Faker::Date.backward.to_s,
          consulted_gender: %w[M F].sample,
          birth_city: Faker::Address.city,
          marital_status: Faker::Lorem.word,
          dependent_number: Faker::Number.number(digits: 1).to_s,
          educational_level: Faker::Lorem.word,
          revenue_situation: Faker::Lorem.word,
          update_date: Faker::Date.backward.to_s,
          cpf_zone: Faker::Lorem.word,
          voter_title: Faker::Lorem.word,
          death: Faker::Boolean.boolean.to_s,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::DebitOccurrence.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          total_debtor: Faker::Number.number(digits: 2).to_s,
          total_guarantor: Faker::Number.number(digits: 2).to_s,
          accumulated_value: Faker::Number.decimal(l_digits: 3,
                                                   r_digits: 2).to_s,
          first_debit_date: Faker::Date.backward.to_s,
          first_debit_value: Faker::Number.decimal(l_digits: 3,
                                                   r_digits: 2).to_s,
          biggest_debit_date: Faker::Date.backward.to_s,
          biggest_debit_value: Faker::Number.decimal(l_digits: 3,
                                                     r_digits: 2).to_s,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::Location.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          public_place_type: Faker::Lorem.word,
          public_place_name: Faker::Address.street_name,
          public_place_number: Faker::Address.building_number,
          complement: Faker::Address.secondary_address,
          neighborhood: Faker::Address.community,
          city: Faker::Address.city,
          federative_unit: Faker::Address.state_abbr,
          zip_code: Faker::Address.zip_code,
          ddd_1: Faker::Number.number(digits: 2).to_s, # rubocop:disable Naming/VariableNumber
          phone_1: Faker::PhoneNumber.phone_number, # rubocop:disable Naming/VariableNumber
          ddd_2: Faker::Number.number(digits: 2).to_s, # rubocop:disable Naming/VariableNumber
          phone_2: Faker::PhoneNumber.phone_number, # rubocop:disable Naming/VariableNumber
          ddd_3: Faker::Number.number(digits: 2).to_s, # rubocop:disable Naming/VariableNumber
          phone_3: Faker::PhoneNumber.phone_number, # rubocop:disable Naming/VariableNumber
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::PreviousQuery.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          occurrence_type: Faker::Lorem.word,
          date: Faker::Date.backward.to_s,
          currency: '0',
          value: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s,
          informant: Faker::Lorem.word,
          product: Faker::Lorem.word,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::ChequeAdditionalInformation.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          document_type: Faker::Lorem.word,
          document_number: Faker::Number.number(digits: 10).to_s,
          text: Faker::Lorem.sentence,
          type_of_register: Faker::Lorem.word,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::CurrentAccountHistoric.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          bank: Faker::Bank.name,
          agency: Faker::Bank.name,
          current_account: Faker::Bank.account_number,
          document_type: Faker::Lorem.word,
          document_number: Faker::Number.number(digits: 10).to_s,
          consultation_date: Faker::Date.backward.to_s,
          consultation_hour: Faker::Time.backward.strftime('%H:%M:%S'),
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::Decision.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          document_type: Faker::Lorem.word,
          document: Faker::Lorem.word,
          score: Faker::Number.number(digits: 2).to_s,
          approves: Faker::Boolean.boolean.to_s,
          text: Faker::Lorem.sentence,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::DocumentsName.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          name: Faker::Name.name,
          birth_date: Faker::Date.backward.to_s,
          document_type: Faker::Lorem.word,
          document_number: Faker::Number.number(digits: 10).to_s,
          document_2: Faker::Number.number(digits: 10).to_s, # rubocop:disable Naming/VariableNumber
          document_3: Faker::Number.number(digits: 10).to_s, # rubocop:disable Naming/VariableNumber
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::ListOfReturnsReportedByCcf.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          document_type: Faker::Lorem.word,
          document_number: Faker::Number.number(digits: 10).to_s,
          name: Faker::Name.name,
          bank: Faker::Bank.name,
          agency: Faker::Bank.name,
          reason_12: Faker::Lorem.word, # rubocop:disable Naming/VariableNumber
          last_occurrence_12_date: Faker::Date.backward.to_s,
          reason_13: Faker::Lorem.word, # rubocop:disable Naming/VariableNumber
          last_occurrence_13_date: Faker::Date.backward.to_s,
          reason_14: Faker::Lorem.word, # rubocop:disable Naming/VariableNumber
          last_occurrence_14_date: Faker::Date.backward.to_s,
          reason_99: Faker::Lorem.word, # rubocop:disable Naming/VariableNumber
          last_occurrence_99_date: Faker::Date.backward.to_s,
          bank_name: Faker::Bank.name,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::ReturnsReportedByUser.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          document_type: Faker::Lorem.word,
          document: Faker::Lorem.word,
          bank: Faker::Bank.name,
          agency: Faker::Bank.name,
          current_account: Faker::Bank.account_number,
          initial_cheque: Faker::Number.number(digits: 6).to_s,
          final_cheque: Faker::Number.number(digits: 6).to_s,
          reason: Faker::Lorem.word,
          point: Faker::Lorem.word,
          occurrence_date: Faker::Date.backward.to_s,
          register_date: Faker::Date.backward.to_s,
          currency: '0',
          value: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s,
          informant_code: Faker::Lorem.word,
          informant: Faker::Lorem.word,
          city: Faker::Address.city,
          federative_unit: Faker::Address.state_abbr,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::ChequesStoppedForReason21.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          document_type: Faker::Lorem.word,
          document_number: Faker::Number.number(digits: 10).to_s,
          bank: Faker::Bank.name,
          agency: Faker::Bank.name,
          current_account: Faker::Bank.account_number,
          initial_cheque: Faker::Number.number(digits: 6).to_s,
          final_cheque: Faker::Number.number(digits: 6).to_s,
          point: Faker::Lorem.word,
          occurrence_date: Faker::Date.backward.to_s,
          availability_date: Faker::Date.forward.to_s,
          currency: '0',
          value: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s,
          informant: Faker::Lorem.word,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::HistoricInformedCheque.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          document_type: Faker::Lorem.word,
          document_number: Faker::Number.number(digits: 10).to_s,
          bank: Faker::Bank.name,
          agency: Faker::Bank.name,
          current_account: Faker::Bank.account_number,
          cheque: Faker::Number.number(digits: 6).to_s,
          consultation_date: Faker::Date.backward.to_s,
          consultation_hour: Faker::Time.backward.strftime('%H:%M:%S'),
          network: Faker::Lorem.word,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::PreviousChequeConsultation.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          document_type: Faker::Lorem.word,
          document_number: Faker::Number.number(digits: 10).to_s,
          consultation_type: Faker::Lorem.word,
          credit_date: Faker::Date.backward.to_s,
          credit_hour: Faker::Time.backward.strftime('%H:%M:%S'),
          currency: '0',
          value: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s,
          informant: Faker::Lorem.word,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::SummaryOfReturnsReportedByUser.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          document_type: Faker::Lorem.word,
          document_number: Faker::Number.number(digits: 10).to_s,
          total: Faker::Number.number(digits: 2).to_s,
          first_devolution_date: Faker::Date.backward.to_s,
          last_devolution_date: Faker::Date.backward.to_s,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::ScoreRatingSeveralModel.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          score_type: Faker::Lorem.word,
          score: Faker::Number.number(digits: 3).to_s,
          plan_name: Faker::Lorem.word,
          score_model: Faker::Lorem.word,
          score_name: Faker::Lorem.word,
          numeric_classification: Faker::Lorem.word,
          alphabetic_classification: Faker::Lorem.word,
          probability: Faker::Number.decimal(l_digits: 2, r_digits: 2).to_s,
          text: Faker::Lorem.sentence,
          code_kind_model: Faker::Lorem.word,
          kind_description: Faker::Lorem.word,
          text_2: Faker::Lorem.sentence, # rubocop:disable Naming/VariableNumber
          value: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s,
          message: Faker::Lorem.sentence,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::RecordMessage.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          record_reference: Faker::Lorem.word,
          text: Faker::Lorem.sentence,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::Previous90DaysConsultation.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          total: Faker::Number.number(digits: 2).to_s,
          year_1: Faker::Number.number(digits: 4).to_s, # rubocop:disable Naming/VariableNumber
          month_1: Faker::Number.number(digits: 2).to_s, # rubocop:disable Naming/VariableNumber
          total_1: Faker::Number.number(digits: 2).to_s, # rubocop:disable Naming/VariableNumber
          year_2: Faker::Number.number(digits: 4).to_s, # rubocop:disable Naming/VariableNumber
          month_2: Faker::Number.number(digits: 2).to_s, # rubocop:disable Naming/VariableNumber
          total_2: Faker::Number.number(digits: 2).to_s, # rubocop:disable Naming/VariableNumber
          year_3: Faker::Number.number(digits: 4).to_s, # rubocop:disable Naming/VariableNumber
          month_3: Faker::Number.number(digits: 2).to_s, # rubocop:disable Naming/VariableNumber
          total_3: Faker::Number.number(digits: 2).to_s, # rubocop:disable Naming/VariableNumber
          year_4: Faker::Number.number(digits: 4).to_s, # rubocop:disable Naming/VariableNumber
          month_4: Faker::Number.number(digits: 2).to_s, # rubocop:disable Naming/VariableNumber
          total_4: Faker::Number.number(digits: 2).to_s, # rubocop:disable Naming/VariableNumber
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::ChequeStopped.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          occurrence_type: Faker::Lorem.word,
          document_type: Faker::Lorem.word,
          document_number: Faker::Number.number(digits: 10).to_s,
          bank: Faker::Bank.name,
          agency: Faker::Bank.name,
          current_account: Faker::Bank.account_number,
          cheque: Faker::Number.number(digits: 6).to_s,
          point: Faker::Lorem.word,
          occurrence_date: Faker::Date.backward.to_s,
          availability_date: Faker::Date.forward.to_s,
          informant: Faker::Lorem.word,
          indicator: Faker::Lorem.word,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::SummaryDevolutionReportedByCcf.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          document_type: Faker::Lorem.word,
          document_number: Faker::Number.number(digits: 10).to_s,
          name: Faker::Name.name,
          names_total: Faker::Number.number(digits: 2).to_s,
          devolution_total: Faker::Number.number(digits: 2).to_s,
          reason_12: Faker::Lorem.word,  # rubocop:disable Naming/VariableNumber
          reason_13: Faker::Lorem.word,  # rubocop:disable Naming/VariableNumber
          reason_14: Faker::Lorem.word,  # rubocop:disable Naming/VariableNumber
          reason_99: Faker::Lorem.word,  # rubocop:disable Naming/VariableNumber
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::SummaryPreviousQueryCheque.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          document_type: Faker::Lorem.word,
          document_number: Faker::Number.number(digits: 10).to_s,
          total: Faker::Number.number(digits: 2).to_s,
          value: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s,
          day: Faker::Number.number(digits: 2).to_s,
          day_value: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s,
          pre_dated: Faker::Number.number(digits: 2).to_s,
          pre_dated_value: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::PhoneConfirmation.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          area_code: Faker::Number.number(digits: 2).to_s,
          phone: Faker::PhoneNumber.phone_number,
          document_type: Faker::Lorem.word,
          document_number: Faker::Number.number(digits: 10).to_s,
          name: Faker::Name.name,
          neighborhood: Faker::Address.community,
          zip_code: Faker::Address.zip_code,
          city: Faker::Address.city,
          federative_unit: Faker::Address.state_abbr,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      BoaVista::BankBranchPhonesAddress.create!(
        {
          register_size: Faker::Number.number(digits: 2).to_s,
          register_type: Faker::Lorem.word,
          register: Faker::Lorem.word,
          bank: Faker::Bank.name,
          bank_name: Faker::Bank.name,
          agency: Faker::Bank.name,
          agency_name: Faker::Bank.name,
          address: Faker::Address.street_address,
          neighborhood: Faker::Address.community,
          zip_code: Faker::Address.zip_code,
          city: Faker::Address.city,
          federative_unit: Faker::Address.state_abbr,
          plaza: Faker::Lorem.word,
          area_code: Faker::Number.number(digits: 2).to_s,
          phone_1: Faker::PhoneNumber.phone_number,  # rubocop:disable Naming/VariableNumber
          phone_2: Faker::PhoneNumber.phone_number,  # rubocop:disable Naming/VariableNumber
          reserved: Faker::Lorem.word,
          boa_vista_acerta_essencial_id: acerta_essencial.id
        }
      )

      Serasa::FintechReport.create!(
        {
          raw_data: '{}',
          analysis_item_id: analysis_item.id,
          registration_attributes: {
            document_number: Faker::Number.number(digits: 10).to_s,
            consumer_name: Faker::Name.name,
            mother_name: Faker::Name.name,
            birth_date: Faker::Date.birthday(min_age: 18, max_age: 65).to_s,
            status_registration: Faker::Lorem.word,
            status_date: Faker::Date.backward,
            address_attributes: {
              address_line: Faker::Address.street_address,
              district: Faker::Address.community,
              zip_code: Faker::Address.zip_code,
              country: Faker::Address.country,
              city: Faker::Address.city,
              state: Faker::Address.state_abbr
            },
            phone_attributes: {
              region_code: Faker::Address.state_abbr,
              area_code: Faker::Number.number(digits: 2).to_s,
              phone_number: Faker::PhoneNumber.phone_number
            }
          },
          negative_data_attributes: {
            pefin_attributes: {
              items_attributes: [{
                occurrence_date: Faker::Date.backward,
                legal_nature_id: Faker::Number.number(digits: 5).to_s,
                legal_nature: Faker::Lorem.word,
                contract_id: Faker::Number.number(digits: 10).to_s,
                creditor_name: Faker::Company.name,
                amount: Faker::Number.decimal(l_digits: 3, r_digits: 2),
                city: Faker::Address.city,
                federal_unit: Faker::Address.state_abbr,
                principal: Faker::Boolean.boolean
              }],
              summary_attributes: {
                count: Faker::Number.number(digits: 2).to_s,
                balance: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s
              }
            },
            refin_attributes: {
              items_attributes: [{
                occurrence_date: Faker::Date.backward,
                legal_nature_id: Faker::Number.number(digits: 5).to_s,
                legal_nature: Faker::Lorem.word,
                contract_id: Faker::Number.number(digits: 10).to_s,
                creditor_name: Faker::Company.name,
                amount: Faker::Number.decimal(l_digits: 3, r_digits: 2),
                city: Faker::Address.city,
                federal_unit: Faker::Address.state_abbr,
                principal: Faker::Boolean.boolean
              }],
              summary_attributes: {
                count: Faker::Number.number(digits: 2).to_s,
                balance: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s
              }
            },
            check_attributes: {
              items_attributes: [{
                occurrence_date: Faker::Date.backward,
                legal_square: Faker::Lorem.word,
                bank_id: Faker::Number.number(digits: 5),
                bank_name: Faker::Bank.name,
                bank_agency_id: Faker::Number.number(digits: 5),
                check_count: Faker::Number.number(digits: 2),
                city: Faker::Address.city,
                federal_unit: Faker::Address.state_abbr,
                check_number: Faker::Number.number(digits: 6),
                alinea: Faker::Lorem.word
              }],
              summary_attributes: {
                count: Faker::Number.number(digits: 2).to_s,
                balance: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s
              }
            },
            notary_attributes: {
              items_attributes: [{
                occurrence_date: Faker::Date.backward,
                amount: Faker::Number.decimal(l_digits: 3, r_digits: 2),
                office_number: Faker::Number.number(digits: 5).to_s,
                office_name: Faker::Company.name,
                city: Faker::Address.city,
                federal_unit: Faker::Address.state_abbr
              }],
              summary_attributes: {
                count: Faker::Number.number(digits: 2).to_s,
                balance: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s
              }
            }
          },
          score_attributes: {
            score: Faker::Number.number(digits: 3),
            score_model: Faker::Lorem.word,
            range: Faker::Lorem.word,
            default_rate: Faker::Lorem.word,
            code_message: Faker::Number.number(digits: 3),
            message: Faker::Lorem.sentence
          },
          fact_attributes: {
            inquiry_attributes: {
              items_attributes: [
                {
                  occurrence_date: Faker::Date.backward,
                  days_quantity: Faker::Number.number(digits: 2),
                  segment_description: Faker::Lorem.word,
                  serasa_inquiry_id: Faker::Number.number(digits: 2)
                }
              ],
              summary_attributes: {
                count: Faker::Number.number(digits: 2).to_s,
                balance: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s
              }
            },
            stolen_documents_attributes: {
              occurrence_date: Faker::Date.backward,
              inclusion_date: Faker::Time.backward,
              document_type: Faker::Lorem.word,
              document_number: Faker::Number.number(digits: 10).to_s,
              issuing_authority: Faker::Lorem.word,
              detailed_reason: Faker::Lorem.sentence,
              occurrence_state: Faker::Address.state_abbr,
              items_attributes: [
                {
                  occurrence_date: Faker::Date.backward,
                  inclusion_date: Faker::Time.backward,
                  document_type: Faker::Lorem.word,
                  document_number: Faker::Number.number(digits: 10).to_s,
                  issuing_authority: Faker::Lorem.word,
                  detailed_reason: Faker::Lorem.sentence,
                  occurrence_state: Faker::Address.state_abbr
                }
              ],
              summary_attributes: {
                count: Faker::Number.number(digits: 2).to_s,
                balance: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s
              }
            }
          }
        }
      )

      Serasa::Authentication.create!(
        {
          access_token: Faker::Lorem.characters(number: 20),
          expires_in: Faker::Number.number(digits: 4).to_s
        }
      )

      # ProScore module
      pro_score_report = ProScore::Report.create!(
        {
          raw_data: '{}',
          performed_searches: [],
          analysis_item_id: analysis_item.id
        }
      )

      ProScore::FamilyAssistance.create!(
        {
          numero_plugin: Faker::Number.number(digits: 10).to_s,
          valor: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s,
          ultima_data_do_beneficio: Faker::Date.backward.to_s,
          consta_beneficio: Faker::Boolean.boolean.to_s,
          pro_score_report_id: pro_score_report.id
        }
      )

      ProScore::EmergencyAssistance.create!(
        {
          numero_plugin: Faker::Number.number(digits: 10).to_s,
          mes_disponibilizado: Faker::Date.backward.strftime('%m/%Y'),
          codigo_do_municipio: Faker::Number.number(digits: 6).to_s,
          municipio: Faker::Address.city,
          uf: Faker::Address.state_abbr,
          parcelas: Faker::Number.number(digits: 1).to_s,
          valor: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s,
          enquadramento: Faker::Lorem.word,
          observacao: Faker::Lorem.sentence,
          pro_score_report_id: pro_score_report.id
        }
      )

      ProScore::MonthlyBenefit.create!(
        {
          numero_plugin: Faker::Number.number(digits: 10).to_s,
          mes_competencia: Faker::Date.backward.strftime('%m/%Y'),
          mes_referencia: Faker::Date.backward.strftime('%m/%Y'),
          uf: Faker::Address.state_abbr,
          nome_municipio: Faker::Address.city,
          nis_beneficiario: Faker::Number.number(digits: 11).to_s,
          numero_beneficio: Faker::Number.number(digits: 10).to_s,
          beneficio_concedido_judicialmente: Faker::Boolean.boolean.to_s,
          valor_parcela: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s,
          pro_score_report_id: pro_score_report.id
        }
      )

      ProScore::FamilyHolding.create!(
        {
          numero_plugin: Faker::Number.number(digits: 10).to_s,
          cpf_do_parente: Faker::CPF.pretty,
          nome_do_parente: Faker::Name.name,
          grau_de_parentesco: %w[MOTHER FATHER SPOUSE CHILD COUSIN].sample,
          pro_score_report_id: pro_score_report.id
        }
      )

      ProScore::BouncedCheck.create!(
        {
          numero_plugin: Faker::Number.number(digits: 10).to_s,
          codigo_do_banco: Faker::Number.number(digits: 4).to_s,
          nome_do_banco: Faker::Bank.name,
          numero_da_agencia: Faker::Number.number(digits: 4).to_s,
          quantidade_de_ocorrencias: Faker::Number.number(digits: 2).to_s,
          motivo_da_ocorrencia: Faker::Lorem.word,
          data_da_ultima_ocorrencia: Faker::Date.backward.to_s,
          pro_score_report_id: pro_score_report.id
        }
      )

      ProScore::CommercialRelation.create!(
        {
          numero_plugin: Faker::Number.number(digits: 10).to_s,
          cpfcnpj: Faker::Number.number(digits: 14).to_s,
          razao_social: Faker::Company.name,
          pro_score_report_id: pro_score_report.id
        }
      )

      ProScore::CriminalAntecedent.create!(
        {
          numero_plugin: Faker::Number.number(digits: 10).to_s,
          numero_da_certidao: Faker::Number.number(digits: 10).to_s,
          certidao: Faker::Lorem.word,
          data_da_emissao: Faker::Date.backward.to_s,
          hora_da_emissao: Faker::Time.backward.strftime('%H:%M:%S'),
          pro_score_report_id: pro_score_report.id
        }
      )

      ProScore::ProprableProfession.create!(
        {
          numero_plugin: Faker::Number.number(digits: 10).to_s,
          codigo: Faker::Number.number(digits: 5).to_s,
          titulo: Faker::Job.title,
          pro_score_report_id: pro_score_report.id
        }
      )

      ProScore::PresumedSalaryRange.create!(
        {
          numero_plugin: Faker::Number.number(digits: 10).to_s,
          codigo_da_faixa_salarial: Faker::Number.number(digits: 5).to_s,
          faixa_salarial: "#{Faker::Number.number(digits: 3)}K A #{Faker::Number.number(digits: 3)}K",
          descricao_da_faixa: Faker::Lorem.sentence,
          pro_score_report_id: pro_score_report.id
        }
      )

      ProScore::PresumedIncome.create!(
        {
          numero_plugin: Faker::Number.number(digits: 10).to_s,
          valor_da_renda_presumida: Faker::Number.decimal(l_digits: 3,
                                                          r_digits: 2).to_s,
          pro_score_report_id: pro_score_report.id
        }
      )

      pro_score_trial = ProScore::Trial.create!(
        {
          numero_plugin: Faker::Number.number(digits: 10).to_s,
          numero_do_processo_unico: Faker::Number.number(digits: 10).to_s,
          data_distribuicao: Faker::Date.backward,
          area: Faker::Lorem.word,
          causa_moeda: Faker::Currency.code,
          causa_valor: Faker::Number.decimal(l_digits: 3, r_digits: 2).to_s,
          unidade_origem: Faker::Lorem.word,
          url_processo: Faker::Internet.url,
          sistema: Faker::Lorem.word,
          data_processamento: Faker::Date.backward,
          tribunal: Faker::Lorem.word,
          uf: Faker::Address.state_abbr,
          segmento: Faker::Lorem.word,
          classe_processual_nome: Faker::Lorem.word,
          orgao_julgador: Faker::Lorem.word,
          juiz: Faker::Name.name,
          pro_score_report_id: pro_score_report.id
        }
      )

      ProScore::TrialPart.create!(
        {
          numero_plugin: Faker::Number.number(digits: 10).to_s,
          numero_do_processo_unico: Faker::Number.number(digits: 10).to_s,
          nome: Faker::Name.name,
          documento: Faker::Number.number(digits: 10).to_s,
          tipo: Faker::Lorem.word,
          polo: Faker::Lorem.word,
          pro_score_trial_id: pro_score_trial.id
        }
      )

      ProScore::TrialTopic.create!(
        {
          numero_plugin: Faker::Number.number(digits: 10).to_s,
          numero_do_processo_unico: Faker::Number.number(digits: 10).to_s,
          codigo_cnpj: Faker::Number.number(digits: 14).to_s,
          titulo: Faker::Lorem.word,
          pro_score_trial_id: pro_score_trial.id
        }
      )

      ProScore::TrialMotion.create!(
        {
          numero_plugin: Faker::Number.number(digits: 10).to_s,
          numero_do_processo_unico: Faker::Number.number(digits: 10).to_s,
          data: Faker::Date.backward,
          nome_original: Faker::Lorem.word,
          pro_score_trial_id: pro_score_trial.id
        }
      )

      ProScore::TrialLawyer.create!(
        {
          numero_plugin: Faker::Number.number(digits: 10).to_s,
          numero_do_processo_unico: Faker::Number.number(digits: 10).to_s,
          advogado_nome: Faker::Name.name,
          parte_nome: Faker::Name.name,
          cpf: Faker::CPF.pretty,
          cnpj: Faker::Number.number(digits: 14).to_s,
          tipo: Faker::Lorem.word,
          oab_numero: Faker::Number.number(digits: 6).to_s,
          oab_uf: Faker::Address.state_abbr,
          pro_score_trial_id: pro_score_trial.id
        }
      )

      ProScore::Authentication.create!(
        {
          token_type: Faker::Lorem.word,
          refresh_token: Faker::Lorem.characters(number: 20),
          access_token: Faker::Lorem.characters(number: 20),
          expires_in: Faker::Number.number(digits: 4)
        }
      )

      # Provenir module
      Provenir::BigDataCorp.create!(
        {
          analysis_item: analysis_item,
          basic_data_attributes: {
            tax_id_number: Faker::CPF.pretty,
            tax_id_country: Faker::Address.country,
            name: Faker::Name.name,
            gender: %w[M F].sample,
            name_word_count: Faker::Number.number(digits: 1),
            number_of_full_name_namesakes: Faker::Number.number(digits: 1),
            name_uniqueness_score: Faker::Number.decimal(l_digits: 1,
                                                         r_digits: 2),
            first_name_uniqueness_score: Faker::Number.decimal(l_digits: 1,
                                                               r_digits: 2),
            first_and_last_name_uniqueness_score: Faker::Number.decimal(
              l_digits: 1, r_digits: 2
            ),
            birth_date: Faker::Date.birthday(
              min_age: 18, max_age: 65
            ),
            age: Faker::Number.number(digits: 2),
            zodiac_sign: Faker::Creature::Animal.name,
            chinese_sign: Faker::Creature::Animal.name,
            birth_country: Faker::Address.country,
            mother_name: Faker::Name.name,
            father_name: Faker::Name.name,
            marital_status_data: Faker::Lorem.word,
            tax_id_status: Faker::Lorem.word,
            tax_id_origin: Faker::Lorem.word,
            tax_id_fiscal_region: Faker::Lorem.word,
            has_obit_indication: Faker::Boolean.boolean,
            tax_id_status_date: Faker::Date.forward,
            tax_id_status_registration_date: Faker::Date.backward,
            creation_date: Faker::Date.backward,
            last_update_date: Faker::Date.backward,
            alternative_id_number_attributes: {},
            extended_document_information_attributes: {
              rg_attributes: {
                document_last4_digits: Faker::Number.number(digits: 4).to_s,
                creation_date: Faker::Date.in_date_period,
                last_update_date: Faker::Date.in_date_period,
                source_attributes: {
                  ENADE: Faker::Lorem.word
                }
              }
            },
            aliases_attributes: {
              common_name: Faker::Name.name,
              standardized_name: Faker::Name.name
            }
          },
          extended_addresses_attributes: {
            total_addresses: Faker::Number.number(digits: 1),
            total_active_addresses: Faker::Number.number(digits: 1),
            total_work_addresses: Faker::Number.number(digits: 1),
            total_personal_addresses: Faker::Number.number(digits: 1),
            total_unique_addresses: Faker::Number.number(digits: 1),
            total_address_passages: Faker::Number.number(digits: 1),
            total_bad_address_passages: Faker::Number.number(digits: 1),
            oldest_address_passage_date: Faker::Date.backward,
            newest_address_passage_date: Faker::Date.forward,
            addresses_attributes: [
              {
                typology: %w[R C].sample,
                title: Faker::Lorem.word,
                address_main: Faker::Address.street_name,
                number: Faker::Address.building_number,
                complement: Faker::Address.secondary_address,
                neighborhood: Faker::Address.community,
                zip_code: Faker::Address.zip_code,
                city: Faker::Address.city,
                state: Faker::Address.state_abbr,
                country: Faker::Address.country,
                address_type: %w[WORK HOME].sample,
                address_currently_in_rf_site: Faker::Boolean.boolean,
                complement_type: Faker::Lorem.word,
                build_code: Faker::Lorem.word,
                building_code: Faker::Lorem.word,
                household_code: Faker::Lorem.word,
                address_entity_age: Faker::Number.number(digits: 3),
                address_entity_total_passages: Faker::Number.number(digits: 2),
                address_entity_bad_passages: Faker::Number.number(digits: 2),
                address_entity_crawling_passages: Faker::Number
                  .number(digits: 2),
                address_entity_validation_passages: Faker::Number
                  .number(digits: 2),
                address_entity_query_passages: Faker::Number.number(digits: 2),
                address_entity_month_average_passages: Faker::Number
                  .number(digits: 2),
                address_global_age: Faker::Number.number(digits: 2),
                address_global_total_passages: Faker::Number.number(digits: 2),
                address_global_bad_passages: Faker::Number.number(digits: 2),
                address_global_crawling_passages: Faker::Number
                  .number(digits: 2),
                address_global_validation_passages: Faker::Number
                  .number(digits: 2),
                address_global_query_passages: Faker::Number.number(digits: 2),
                address_global_month_average_passages: Faker::Number
                  .number(digits: 2),
                address_number_of_entities: Faker::Number.number(digits: 2),
                priority: Faker::Number.number(digits: 1),
                is_main_for_entity: Faker::Boolean.boolean,
                is_recent_for_entity: Faker::Boolean.boolean,
                is_main_for_other_entity: Faker::Boolean.boolean,
                is_recent_for_other_entity: Faker::Boolean.boolean,
                is_active: Faker::Boolean.boolean,
                is_ratified: Faker::Boolean.boolean,
                is_likely_from_accountant: Faker::Boolean.boolean,
                last_validation_date: Faker::Date.backward,
                entity_first_passage_date: Faker::Date.backward,
                entity_last_passage_date: Faker::Date.backward,
                global_first_passage_date: Faker::Date.backward,
                global_last_passage_date: Faker::Date.backward,
                creation_date: Faker::Date.backward,
                last_update_date: Faker::Date.backward,
                has_opt_in: Faker::Boolean.boolean,
                latitude: Faker::Address.latitude,
                longitude: Faker::Address.longitude
              },
              {
                typology: %w[R C].sample,
                title: Faker::Lorem.word,
                address_main: Faker::Address.street_name,
                number: Faker::Address.building_number,
                complement: Faker::Address.secondary_address,
                neighborhood: Faker::Address.community,
                zip_code: Faker::Address.zip_code,
                city: Faker::Address.city,
                state: Faker::Address.state_abbr,
                country: Faker::Address.country,
                address_type: %w[WORK HOME].sample,
                address_currently_in_rf_site: Faker::Boolean.boolean,
                complement_type: Faker::Lorem.word,
                build_code: Faker::Lorem.word,
                building_code: Faker::Lorem.word,
                household_code: Faker::Lorem.word,
                address_entity_age: Faker::Number.number(digits: 3),
                address_entity_total_passages: Faker::Number.number(digits: 2),
                address_entity_bad_passages: Faker::Number.number(digits: 2),
                address_entity_crawling_passages: Faker::Number
                  .number(digits: 2),
                address_entity_validation_passages: Faker::Number
                  .number(digits: 2),
                address_entity_query_passages: Faker::Number.number(digits: 2),
                address_entity_month_average_passages: Faker::Number
                  .number(digits: 2),
                address_global_age: Faker::Number.number(digits: 2),
                address_global_total_passages: Faker::Number.number(digits: 2),
                address_global_bad_passages: Faker::Number.number(digits: 2),
                address_global_crawling_passages: Faker::Number
                  .number(digits: 2),
                address_global_validation_passages: Faker::Number
                  .number(digits: 2),
                address_global_query_passages: Faker::Number.number(digits: 2),
                address_global_month_average_passages: Faker::Number
                  .number(digits: 2),
                address_number_of_entities: Faker::Number.number(digits: 2),
                priority: Faker::Number.number(digits: 1),
                is_main_for_entity: Faker::Boolean.boolean,
                is_recent_for_entity: Faker::Boolean.boolean,
                is_main_for_other_entity: Faker::Boolean.boolean,
                is_recent_for_other_entity: Faker::Boolean.boolean,
                is_active: Faker::Boolean.boolean,
                is_ratified: Faker::Boolean.boolean,
                is_likely_from_accountant: Faker::Boolean.boolean,
                last_validation_date: Faker::Date.backward,
                entity_first_passage_date: Faker::Date.backward,
                entity_last_passage_date: Faker::Date.backward,
                global_first_passage_date: Faker::Date.backward,
                global_last_passage_date: Faker::Date.backward,
                creation_date: Faker::Date.backward,
                last_update_date: Faker::Date.backward,
                has_opt_in: Faker::Boolean.boolean,
                latitude: Faker::Address.latitude,
                longitude: Faker::Address.longitude
              }
            ]
          },
          extended_phones_attributes: {
            total_phones: 2,
            total_active_phones: Faker::Number.number(digits: 1),
            total_work_phones: Faker::Number.number(digits: 1),
            total_personal_phones: Faker::Number.number(digits: 1),
            total_unique_phones: Faker::Number.number(digits: 1),
            total_phone_passages: Faker::Number.number(digits: 1),
            total_bad_phone_passages: Faker::Number.number(digits: 1),
            total_last3_months_passages: Faker::Number.number(digits: 1),
            total_last6_months_passages: Faker::Number.number(digits: 1),
            total_last12_months_passages: Faker::Number.number(digits: 1),
            total_last18_months_passages: Faker::Number.number(digits: 1),
            oldest_phone_passage_date: Faker::Date.backward,
            newest_phone_passage_date: Faker::Date.forward,
            phones_attributes: [
              {
                number: Faker::PhoneNumber.cell_phone,
                complement: Faker::Lorem.word,
                area_code: Faker::Number.number(digits: 2),
                neighborhood: Faker::Address.community,
                zip_code: Faker::Address.zip_code,
                city: Faker::Address.city,
                state: Faker::Address.state,
                country: Faker::Address.country,
                phone_type: %w[MOBILE
                               LANDLINE].sample,
                address_currently_in_rf_site: Faker::Lorem.word,
                complement_type: Faker::Lorem.word,
                build_code: Faker::Lorem.word,
                building_code: Faker::Lorem.word,
                household_code: Faker::Lorem.word,
                address_entity_age: Faker::Lorem.word,
                country_code: Faker::Number.number(digits: 2),
                phone_currently_in_rf_site: Faker::Boolean.boolean,
                phone_entity_total_passages: Faker::Number.number(digits: 2),
                phone_entity_bad_passages: Faker::Number.number(digits: 2),
                phone_entity_crawling_passages: Faker::Number.number(digits: 2),
                phone_entity_validation_passages: Faker::Number
                  .number(digits: 2),
                phone_entity_query_passages: Faker::Number.number(digits: 2),
                phone_entity_month_average_passages: Faker::Number
                  .number(digits: 2),
                phone_global_age: Faker::Number.number(digits: 2),
                phone_global_total_passages: Faker::Number.number(digits: 2),
                phone_global_bad_passages: Faker::Number.number(digits: 2),
                phone_global_crawling_passages: Faker::Number.number(digits: 2),
                phone_global_validation_passages: Faker::Number
                  .number(digits: 2),
                phone_global_query_passages: Faker::Number.number(digits: 2),
                phone_global_month_average_passages: Faker::Number
                  .number(digits: 2),
                last3_months_passages: Faker::Number.number(digits: 2),
                last6_months_passages: Faker::Number.number(digits: 2),
                last12_months_passages: Faker::Number.number(digits: 2),
                last18_months_passages: Faker::Number.number(digits: 2),
                phone_number_of_entities: Faker::Number.number(digits: 2),
                phone_number_of_family_related_entities: Faker::Number
                  .number(digits: 2),
                phone_number_of_related_entities: Faker::Number
                  .number(digits: 2),
                priority: Faker::Number.number(digits: 1),
                is_main_for_entity: Faker::Boolean.boolean,
                is_recent_for_entity: Faker::Boolean.boolean,
                is_main_for_other_entity: Faker::Boolean.boolean,
                is_recent_for_other_entity: Faker::Boolean.boolean,
                is_active: Faker::Boolean.boolean,
                is_likely_from_accountant: Faker::Boolean.boolean,
                is_in_do_not_call_list: Faker::Boolean.boolean,
                current_carrier: Faker::Lorem.word
              },
              {
                number: Faker::PhoneNumber.cell_phone,
                complement: Faker::Lorem.word,
                area_code: Faker::Number.number(digits: 2),
                neighborhood: Faker::Address.community,
                zip_code: Faker::Address.zip_code,
                city: Faker::Address.city,
                state: Faker::Address.state,
                country: Faker::Address.country,
                phone_type: %w[MOBILE
                               LANDLINE].sample,
                address_currently_in_rf_site: Faker::Lorem.word,
                complement_type: Faker::Lorem.word,
                build_code: Faker::Lorem.word,
                building_code: Faker::Lorem.word,
                household_code: Faker::Lorem.word,
                address_entity_age: Faker::Lorem.word,
                country_code: Faker::Number.number(digits: 2),
                phone_currently_in_rf_site: Faker::Boolean.boolean,
                phone_entity_total_passages: Faker::Number.number(digits: 2),
                phone_entity_bad_passages: Faker::Number.number(digits: 2),
                phone_entity_crawling_passages: Faker::Number.number(digits: 2),
                phone_entity_validation_passages: Faker::Number
                  .number(digits: 2),
                phone_entity_query_passages: Faker::Number.number(digits: 2),
                phone_entity_month_average_passages: Faker::Number
                  .number(digits: 2),
                phone_global_age: Faker::Number.number(digits: 2),
                phone_global_total_passages: Faker::Number.number(digits: 2),
                phone_global_bad_passages: Faker::Number.number(digits: 2),
                phone_global_crawling_passages: Faker::Number.number(digits: 2),
                phone_global_validation_passages: Faker::Number
                  .number(digits: 2),
                phone_global_query_passages: Faker::Number.number(digits: 2),
                phone_global_month_average_passages: Faker::Number
                  .number(digits: 2),
                last3_months_passages: Faker::Number.number(digits: 2),
                last6_months_passages: Faker::Number.number(digits: 2),
                last12_months_passages: Faker::Number.number(digits: 2),
                last18_months_passages: Faker::Number.number(digits: 2),
                phone_number_of_entities: Faker::Number.number(digits: 2),
                phone_number_of_family_related_entities: Faker::Number
                  .number(digits: 2),
                phone_number_of_related_entities: Faker::Number
                  .number(digits: 2),
                priority: Faker::Number.number(digits: 1),
                is_main_for_entity: Faker::Boolean.boolean,
                is_recent_for_entity: Faker::Boolean.boolean,
                is_main_for_other_entity: Faker::Boolean.boolean,
                is_recent_for_other_entity: Faker::Boolean.boolean,
                is_active: Faker::Boolean.boolean,
                is_likely_from_accountant: Faker::Boolean.boolean,
                is_in_do_not_call_list: Faker::Boolean.boolean,
                current_carrier: Faker::Lorem.word
              }
            ]
          },
          finantial_data_attributes: {
            total_assets: "#{Faker::Number.number(digits: 3)}K A #{Faker::Number.number(digits: 3)}K",
            creation_date: Faker::Date.backward,
            last_update_date: Faker::Date.backward,
            tax_returns_attributes: [
              {
                year: Faker::Date.backward,
                status: %w[CREDITADA
                           DEBITADA].sample,
                bank: Faker::Bank.name,
                branch: Faker::Bank.name,
                batch: Faker::Bank.name,
                is_vip_branch: Faker::Boolean.boolean,
                capture_date: Faker::Date.backward,
                creation_date: Faker::Date.backward,
                last_update_date: Faker::Date.backward
              },
              {
                year: Faker::Date.backward,
                status: %w[CREDITADA
                           DEBITADA].sample,
                bank: Faker::Bank.name,
                branch: Faker::Bank.name,
                batch: Faker::Bank.name,
                is_vip_branch: Faker::Boolean.boolean,
                capture_date: Faker::Date.backward,
                creation_date: Faker::Date.backward,
                last_update_date: Faker::Date.backward
              },
              {
                year: Faker::Date.backward,
                status: %w[CREDITADA
                           DEBITADA].sample,
                bank: Faker::Bank.name,
                branch: Faker::Bank.name,
                batch: Faker::Bank.name,
                is_vip_branch: Faker::Boolean.boolean,
                capture_date: Faker::Date.backward,
                creation_date: Faker::Date.backward,
                last_update_date: Faker::Date.backward
              },
              {
                year: Faker::Date.backward,
                status: %w[CREDITADA
                           DEBITADA].sample,
                bank: Faker::Bank.name,
                branch: Faker::Bank.name,
                batch: Faker::Bank.name,
                is_vip_branch: Faker::Boolean.boolean,
                capture_date: Faker::Date.backward,
                creation_date: Faker::Date.backward,
                last_update_date: Faker::Date.backward
              },
              { # This one is empty on purpose to test the BlankObjectFilterable concern
                year: nil,
                status: nil,
                bank: nil,
                branch: nil,
                batch: nil,
                is_vip_branch: nil,
                capture_date: nil,
                creation_date: nil,
                last_update_date: nil
              }
            ],
            income_estimates_attributes: {
              mte: "#{rand(1..999)}K A #{rand(1..999)}K",
              company_ownership: "#{rand(1..999)}K A #{rand(1..999)}K",
              ibge: "#{rand(1..999)}K A #{rand(1..999)}K",
              bigdata: "#{rand(1..999)}K A #{rand(1..999)}K",
              bigdata_v2: "#{rand(1..999)}K A #{rand(1..999)}K"
            }
          },
          financial_risk_attributes: {
            total_assets: "#{rand(1..999)}K A #{rand(1..999)}K",
            estimated_income_range: "#{rand(1..99)} A #{rand(1..99)} SM",
            is_currently_employed: Faker::Boolean.boolean,
            is_currently_owner: Faker::Boolean.boolean,
            last_occupation_start_date: Faker::Date.backward,
            is_currently_on_collection: Faker::Boolean.boolean,
            last365_days_collection_occurrences: Faker::Number
              .number(digits: 1),
            current_consecutive_collection_months: Faker::Number
              .number(digits: 1),
            is_currently_receiving_assistance: Faker::Boolean.boolean,
            financial_risk_score: Faker::Number.number(digits: 3),
            financial_risk_level: Faker::Lorem.word
          },
          processes_attributes: {
            lawsuits_attributes: [
              {
                lawsuit_number: Faker::Number.number(digits: 10).to_s,
                lawsuit_type: Faker::Lorem.word,
                main_subject: Faker::Lorem.word,
                court_name: Faker::Lorem.word,
                court_level: Faker::Lorem.word,
                court_type: Faker::Lorem.word,
                court_district: Faker::Lorem.word,
                judging_body: Faker::Lorem.word,
                state: Faker::Address.state_abbr,
                status: Faker::Lorem.word,
                lawsuit_host_service: Faker::Lorem.word,
                inferred_cnj_subject_name: Faker::Lorem.word,
                inferred_cnj_subject_number: Faker::Lorem.word,
                inferred_cnj_procedure_type_name: Faker::Lorem.word,
                inferred_broad_cnj_subject_name: Faker::Lorem.word,
                inferred_broad_cnj_subject_number: Faker::Lorem.word,
                number_of_volumes: Faker::Number.decimal(l_digits: 1),
                number_of_pages: Faker::Number.decimal(l_digits: 3),
                value: Faker::Number.decimal(l_digits: 5),
                res_judicata_date: Faker::Date.backward,
                close_date: Faker::Date.backward,
                redistribution_date: Faker::Date.backward,
                publication_date: Faker::Date.backward,
                notice_date: Faker::Date.backward,
                last_movement_date: Faker::Date.backward,
                capture_date: Faker::Date.backward,
                last_update: Faker::Date.backward,
                number_of_parties: 5,
                number_of_updates: 5,
                law_suit_age: Faker::Number.number(digits: 4),
                average_number_of_updates_per_month: Faker::Number
                  .number(digits: 1),
                reason_for_concealed_data: Faker::Number.number(digits: 1),
                decisions_attributes: [
                  {
                    decision_content: Faker::Lorem.sentence,
                    decision_date: Faker::Date.backward
                  },
                  {
                    decision_content: Faker::Lorem.sentence,
                    decision_date: Faker::Date.backward
                  },
                  {
                    decision_content: Faker::Lorem.sentence,
                    decision_date: Faker::Date.backward
                  },
                  {
                    decision_content: Faker::Lorem.sentence,
                    decision_date: Faker::Date.backward
                  },
                  {
                    decision_content: Faker::Lorem.sentence,
                    decision_date: Faker::Date.backward
                  }
                ],
                parties_attributes: [
                  {
                    party_doc: Faker::IdNumber.brazilian_citizen_number,
                    is_party_active: Faker::Boolean.boolean,
                    name: Faker::Name.name,
                    polarity: %w[NEUTRAL ACTIVE
                                 PASSIVE].sample,
                    party_type: %w[LAWYER AUTHOR
                                   DEFENDANT].sample,
                    last_capture_date: Faker::Date.backward
                  },
                  {
                    party_doc: Faker::IdNumber.brazilian_citizen_number,
                    is_party_active: Faker::Boolean.boolean,
                    name: Faker::Name.name,
                    polarity: %w[NEUTRAL ACTIVE
                                 PASSIVE].sample,
                    party_type: %w[LAWYER AUTHOR
                                   DEFENDANT].sample,
                    last_capture_date: Faker::Date.backward
                  },
                  {
                    party_doc: Faker::IdNumber.brazilian_citizen_number,
                    is_party_active: Faker::Boolean.boolean,
                    name: Faker::Name.name,
                    polarity: %w[NEUTRAL ACTIVE
                                 PASSIVE].sample,
                    party_type: %w[LAWYER AUTHOR
                                   DEFENDANT].sample,
                    last_capture_date: Faker::Date.backward
                  },
                  {
                    party_doc: Faker::IdNumber.brazilian_citizen_number,
                    is_party_active: Faker::Boolean.boolean,
                    name: Faker::Name.name,
                    polarity: %w[NEUTRAL ACTIVE
                                 PASSIVE].sample,
                    party_type: %w[LAWYER AUTHOR
                                   DEFENDANT].sample,
                    last_capture_date: Faker::Date.backward
                  },
                  {
                    party_doc: Faker::IdNumber.brazilian_citizen_number,
                    is_party_active: Faker::Boolean.boolean,
                    name: Faker::Name.name,
                    polarity: %w[NEUTRAL ACTIVE
                                 PASSIVE].sample,
                    party_type: %w[LAWYER AUTHOR
                                   DEFENDANT].sample,
                    last_capture_date: Faker::Date.backward
                  }
                ],
                petitions_attributes: [{}],
                updates_attributes: [
                  {
                    content: Faker::Lorem.sentence,
                    publish_date: Faker::Date.backward,
                    capture_date: Faker::Date.backward
                  },
                  {
                    content: Faker::Lorem.sentence,
                    publish_date: Faker::Date.backward,
                    capture_date: Faker::Date.backward
                  },
                  {
                    content: Faker::Lorem.sentence,
                    publish_date: Faker::Date.backward,
                    capture_date: Faker::Date.backward
                  },
                  {
                    content: Faker::Lorem.sentence,
                    publish_date: Faker::Date.backward,
                    capture_date: Faker::Date.backward
                  },
                  {
                    content: Faker::Lorem.sentence,
                    publish_date: Faker::Date.backward,
                    capture_date: Faker::Date.backward
                  }
                ]
              }
            ]
          },
          related_people_attributes: {
            total_relationships: 5,
            total_relatives: Faker::Number.number(digits: 1),
            total_neighbors: Faker::Number.number(digits: 1),
            total_spouses: Faker::Number.number(digits: 1),
            total_coworkers: Faker::Number.number(digits: 1),
            total_household: Faker::Number.number(digits: 1),
            total_partners: Faker::Number.number(digits: 1),
            total_college_class: Faker::Number.number(digits: 1),
            personal_relationships_attributes: [
              {
                related_entity_tax_id_number: Faker::CPF.pretty,
                related_entity_tax_id_type: 'CPF',
                related_entity_tax_id_country: Faker::Address.country,
                related_entity_name: Faker::Name.name,
                relationship_type: %w[MOTHER FATHER
                                      SPOUSE CHILD COUSIN].sample,
                relationship_level: %w[DIRECT
                                       INDIRECT].sample,
                relationship_start_date: Faker::Date.backward,
                relationship_end_date: Faker::Date.forward,
                creation_date: Faker::Date.backward,
                last_update_date: Faker::Date.forward
              },
              {
                related_entity_tax_id_number: Faker::CPF.pretty,
                related_entity_tax_id_type: 'CPF',
                related_entity_tax_id_country: Faker::Address.country,
                related_entity_name: Faker::Name.name,
                relationship_type: %w[MOTHER FATHER
                                      SPOUSE CHILD COUSIN].sample,
                relationship_level: %w[DIRECT
                                       INDIRECT].sample,
                relationship_start_date: Faker::Date.backward,
                relationship_end_date: Faker::Date.forward,
                creation_date: Faker::Date.backward,
                last_update_date: Faker::Date.forward
              },
              {
                related_entity_tax_id_number: Faker::CPF.pretty,
                related_entity_tax_id_type: 'CPF',
                related_entity_tax_id_country: Faker::Address.country,
                related_entity_name: Faker::Name.name,
                relationship_type: %w[MOTHER FATHER
                                      SPOUSE CHILD COUSIN].sample,
                relationship_level: %w[DIRECT
                                       INDIRECT].sample,
                relationship_start_date: Faker::Date.backward,
                relationship_end_date: Faker::Date.forward,
                creation_date: Faker::Date.backward,
                last_update_date: Faker::Date.forward
              },
              {
                related_entity_tax_id_number: Faker::CPF.pretty,
                related_entity_tax_id_type: 'CPF',
                related_entity_tax_id_country: Faker::Address.country,
                related_entity_name: Faker::Name.name,
                relationship_type: %w[MOTHER FATHER
                                      SPOUSE CHILD COUSIN].sample,
                relationship_level: %w[DIRECT
                                       INDIRECT].sample,
                relationship_start_date: Faker::Date.backward,
                relationship_end_date: Faker::Date.forward,
                creation_date: Faker::Date.backward,
                last_update_date: Faker::Date.forward
              },
              {
                related_entity_tax_id_number: Faker::CPF.pretty,
                related_entity_tax_id_type: 'CPF',
                related_entity_tax_id_country: Faker::Address.country,
                related_entity_name: Faker::Name.name,
                relationship_type: %w[MOTHER FATHER
                                      SPOUSE CHILD COUSIN].sample,
                relationship_level: %w[DIRECT
                                       INDIRECT].sample,
                relationship_start_date: Faker::Date.backward,
                relationship_end_date: Faker::Date.forward,
                creation_date: Faker::Date.backward,
                last_update_date: Faker::Date.forward
              }
            ]
          },
          collections_attributes: {
            is_currently_on_collection: Faker::Boolean.boolean,
            last30_days_collection_occurrences: Faker::Number.number(digits: 1),
            last90_days_collection_occurrences: Faker::Number.number(digits: 1),
            last180_days_collection_occurrences: Faker::Number
              .number(digits: 1),
            last365_days_collection_occurrences: Faker::Number
              .number(digits: 1),
            last30_days_collection_origins: Faker::Number.number(digits: 1),
            last90_days_collection_origins: Faker::Number.number(digits: 1),
            last180_days_collection_origins: Faker::Number.number(digits: 1),
            last365_days_collection_origins: Faker::Number.number(digits: 1),
            total_collection_months: Faker::Number.number(digits: 1),
            current_consecutive_collection_months: Faker::Number
              .number(digits: 1),
            max_consecutive_collection_months: Faker::Number.number(digits: 1),
            first_collection_date: Faker::Date.backward,
            last_collection_date: Faker::Date.forward,
            collection_occurrences: Faker::Number.number(digits: 1),
            collection_origins: Faker::Number.number(digits: 1)
          },
          business_relationships_attributes: {
            total_relationships: 5,
            total_ownerships: Faker::Number.number(digits: 1),
            total_employments: Faker::Number.number(digits: 1),
            total_partners: Faker::Number.number(digits: 1),
            total_clients: Faker::Number.number(digits: 1),
            total_suppliers: Faker::Number.number(digits: 1),
            business_relationships_items_attributes: [
              {
                related_entity_tax_id_number: CNPJ.new(CNPJ.generate).formatted,
                related_entity_tax_id_type: 'CNPJ',
                related_entity_tax_id_country: Faker::Address.country,
                related_entity_name: Faker::Name.name,
                relationship_name: %w[OWNER
                                      SOCIO].sample,
                relationship_type: %w[OWNERSHIP LEGAL REPRESENTATIVE EMPLOYMENT
                                      PARTNER].sample,
                relationship_subtype: %w[OWNER].sample,
                relationship_level: %w[DIRECT
                                       INDIRECT].sample,
                relationship_start_date: Faker::Date.backward,
                relationship_end_date: Faker::Date.forward,
                creation_date: Faker::Date.backward,
                last_update_date: Faker::Date.forward,
                additional_details: Faker::Lorem.sentence
              },
              {
                related_entity_tax_id_number: CNPJ.new(CNPJ.generate).formatted,
                related_entity_tax_id_type: 'CNPJ',
                related_entity_tax_id_country: Faker::Address.country,
                related_entity_name: Faker::Name.name,
                relationship_name: %w[OWNER
                                      SOCIO].sample,
                relationship_type: %w[OWNERSHIP LEGAL REPRESENTATIVE EMPLOYMENT
                                      PARTNER].sample,
                relationship_subtype: %w[OWNER].sample,
                relationship_level: %w[DIRECT
                                       INDIRECT].sample,
                relationship_start_date: Faker::Date.backward,
                relationship_end_date: Faker::Date.forward,
                creation_date: Faker::Date.backward,
                last_update_date: Faker::Date.forward,
                additional_details: Faker::Lorem.sentence
              },
              {
                related_entity_tax_id_number: CNPJ.new(CNPJ.generate).formatted,
                related_entity_tax_id_type: 'CNPJ',
                related_entity_tax_id_country: Faker::Address.country,
                related_entity_name: Faker::Name.name,
                relationship_name: %w[OWNER
                                      SOCIO].sample,
                relationship_type: %w[OWNERSHIP LEGAL REPRESENTATIVE EMPLOYMENT
                                      PARTNER].sample,
                relationship_subtype: %w[OWNER].sample,
                relationship_level: %w[DIRECT
                                       INDIRECT].sample,
                relationship_start_date: Faker::Date.backward,
                relationship_end_date: Faker::Date.forward,
                creation_date: Faker::Date.backward,
                last_update_date: Faker::Date.forward,
                additional_details: Faker::Lorem.sentence
              },
              {
                related_entity_tax_id_number: CNPJ.new(CNPJ.generate).formatted,
                related_entity_tax_id_type: 'CNPJ',
                related_entity_tax_id_country: Faker::Address.country,
                related_entity_name: Faker::Name.name,
                relationship_name: %w[OWNER
                                      SOCIO].sample,
                relationship_type: %w[OWNERSHIP LEGAL REPRESENTATIVE EMPLOYMENT
                                      PARTNER].sample,
                relationship_subtype: %w[OWNER].sample,
                relationship_level: %w[DIRECT
                                       INDIRECT].sample,
                relationship_start_date: Faker::Date.backward,
                relationship_end_date: Faker::Date.forward,
                creation_date: Faker::Date.backward,
                last_update_date: Faker::Date.forward,
                additional_details: Faker::Lorem.sentence
              },
              {
                related_entity_tax_id_number: CNPJ.new(CNPJ.generate).formatted,
                related_entity_tax_id_type: 'CNPJ',
                related_entity_tax_id_country: Faker::Address.country,
                related_entity_name: Faker::Name.name,
                relationship_name: %w[OWNER
                                      SOCIO].sample,
                relationship_type: %w[OWNERSHIP LEGAL REPRESENTATIVE EMPLOYMENT
                                      PARTNER].sample,
                relationship_subtype: %w[OWNER].sample,
                relationship_level: %w[DIRECT
                                       INDIRECT].sample,
                relationship_start_date: Faker::Date.backward,
                relationship_end_date: Faker::Date.forward,
                creation_date: Faker::Date.backward,
                last_update_date: Faker::Date.forward,
                additional_details: Faker::Lorem.sentence
              }
            ]
          }
        }
      )
    end

    puts('Database populated successfully!'.green.bold)
  end
end
