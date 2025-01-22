# frozen_string_literal: true

module Analysis
  class StepItemSerializer < ApplicationSerializer
    attributes :id, :cpf, :name, :disapproval_situation, :debits,
               :status, :created_at, :prediction, :contracts, :original,
               :error_status, :human_analyzed_prediction,
               :approved, :age, :presumed_income_value, :proprable_profession,
               :bounced_check, :trials

    def original
      object.clone_of&.serialize_record
    end

    def presumed_income_value
      if object.pro_score_presumed_income_value
        return format('%.2f', object.pro_score_presumed_income_value)
      end

      object.provenir_bigdata_v2 || '0.00'
    end

    def proprable_profession
      object.pro_score_proprable_profession
    end

    def bounced_check
      object.pro_score_bounced_check? || false
    end

    def trials
      provider_trials&.map(&:serialize_record)
    end

    def age
      object.boa_vista_cadastral_age
    end

    def contracts
      object_cpf = CPF::Formatter.strip(object.cpf)
      tenants = ::Superlogica::Tenant.where(st_cnpj_pes: object_cpf)
      tenants_contracts = tenants.map(&:superlogica_contracts)
      contracts = tenants_contracts.flatten

      contracts.map(&:serialize_record)
    end

    def human_analyzed_prediction
      human_analyzed&.serialize_record
    end

    def approved
      predictions = object.predictions

      return nil if predictions.blank?
      return human_analyzed.approved if human_analyzed.present?

      predictions.last.approved
    end

    def prediction
      predictions = object.predictions
      property_fee = object.property_fee

      return nil if predictions.blank? || !approved

      prediction = human_analyzed.presence || predictions.last

      return 12.0 if prediction.result.to_s.eql?('9.5') && property_fee.eql?(2)

      prediction.result + property_fee
    end

    def debits
      if boa_vista_acerta_essencial.present?
        return @boa_vista_acerta_essencial.debits.map(&:serialize_record)
      end

      negative_data&.debits&.map(&:serialize_record)
    end

    private

    def boa_vista_acerta_essencial
      @boa_vista_acerta_essencial ||= object.boa_vista_acerta_essencial
    end

    def provider_trials
      object.pro_score_trials || object.provenir_lawsuits
    end

    def serasa_fintech_report
      @serasa_fintech_report ||= object.serasa_fintech_report
    end

    def negative_data
      @negative_data ||= serasa_fintech_report&.negative_data
    end

    def human_analyzed
      object.predictions.find_by(label: 'human_analyzed')
    end
  end
end
