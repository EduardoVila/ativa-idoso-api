# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_acerta_essencials
#
#  id            :bigint           not null, primary key
#  cpf           :string           not null
#  credit_type   :integer          default("CC"), not null
#  raw_data      :string
#  consumer_type :string
#  consumer_id   :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
module BoaVista
  class AcertaEssencial < ApplicationRecord
    enum credit_type: { CC: 0, CD: 1, CG: 2, CH: 3, CP: 4, CV: 5, OU: 6 }

    validates :cpf, presence: true
    validates :credit_type, presence: true

    belongs_to :consumer, polymorphic: true

    has_many :additional_informations,
             class_name: 'BoaVista::AdditionalInformation',
             dependent: :destroy,
             foreign_key: 'boa_vista_acerta_essencial_id',
             inverse_of: :boa_vista_acerta_essencial

    has_many :debits,
             class_name: 'BoaVista::Debit',
             dependent: :destroy,
             foreign_key: 'boa_vista_acerta_essencial_id',
             inverse_of: :boa_vista_acerta_essencial

    has_many :protested_titles,
             class_name: 'BoaVista::ProtestedTitle',
             dependent: :destroy,
             foreign_key: 'boa_vista_acerta_essencial_id',
             inverse_of: :boa_vista_acerta_essencial

    has_one :protested_title_summary,
            class_name: 'BoaVista::ProtestedTitleSummary',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :identification,
            class_name: 'BoaVista::Identification',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :debit_occurrence,
            class_name: 'BoaVista::DebitOccurrence',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :location,
            class_name: 'BoaVista::Location',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_many :previous_queries,
             class_name: 'BoaVista::PreviousQuery',
             dependent: :destroy,
             foreign_key: 'boa_vista_acerta_essencial_id',
             inverse_of: :boa_vista_acerta_essencial

    has_one :cheque_additional_information,
            class_name: 'BoaVista::ChequeAdditionalInformation',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :current_account_historic,
            class_name: 'BoaVista::CurrentAccountHistoric',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :decision,
            class_name: 'BoaVista::Decision',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :zip_code_confirmation,
            class_name: 'BoaVista::ZipCodeConfirmation',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :documents_name,
            class_name: 'BoaVista::DocumentsName',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_many :list_of_returns_reported_by_ccfs,
             class_name: 'BoaVista::ListOfReturnsReportedByCcf',
             dependent: :destroy,
             foreign_key: 'boa_vista_acerta_essencial_id',
             inverse_of: :boa_vista_acerta_essencial

    has_one :returns_reported_by_user,
            class_name: 'BoaVista::ReturnsReportedByUser',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :cheques_stopped_for_reason21,
            class_name: 'BoaVista::ChequesStoppedForReason21',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :historic_informed_cheque,
            class_name: 'BoaVista::HistoricInformedCheque',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :previous_cheque_consultation,
            class_name: 'BoaVista::PreviousChequeConsultation',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :summary_of_returns_reported_by_user,
            class_name: 'BoaVista::SummaryOfReturnsReportedByUser',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_many :score_rating_several_models,
             class_name: 'BoaVista::ScoreRatingSeveralModel',
             dependent: :destroy,
             foreign_key: 'boa_vista_acerta_essencial_id',
             inverse_of: :boa_vista_acerta_essencial

    has_one :record_message,
            class_name: 'BoaVista::RecordMessage',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :previous90_days_consultation,
            class_name: 'BoaVista::Previous90DaysConsultation',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :cheque_stopped,
            class_name: 'BoaVista::ChequeStopped',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :summary_devolution_reported_by_ccf,
            class_name: 'BoaVista::SummaryDevolutionReportedByCcf',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :summary_previous_query_cheque,
            class_name: 'BoaVista::SummaryPreviousQueryCheque',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :phone_confirmation,
            class_name: 'BoaVista::PhoneConfirmation',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    has_one :bank_branch_phones_address,
            class_name: 'BoaVista::BankBranchPhonesAddress',
            dependent: :destroy,
            foreign_key: 'boa_vista_acerta_essencial_id',
            inverse_of: :boa_vista_acerta_essencial

    delegate :name, to: :identification, prefix: true, allow_nil: true
    delegate :birth_date, to: :identification, prefix: true, allow_nil: true

    def debit_approved?
      debits.none?(&:disapproved?)
    end

    def debit_with_maximum_value
      format_values(debits.pluck(:value)).max
    end

    def debit_with_minimum_value
      format_values(debits.pluck(:value)).min
    end

    def debits_total_value
      format_values(debits.pluck(:value)).sum
    end

    def days_since_the_last_debit
      occurrence_dates = debits.pluck(:occurrence_date)

      calculate_days_since_last_occurrence(occurrence_dates)
    end

    def protested_title_with_maximum_value
      format_values(protested_titles.pluck(:value)).max
    end

    def protested_title_with_minimum_value
      format_values(protested_titles.pluck(:value)).min
    end

    def protested_titles_total_value
      format_values(protested_titles.pluck(:value)).sum
    end

    def days_since_the_last_protested_title
      occurrence_dates = protested_titles.pluck(:occurrence_date)

      calculate_days_since_last_occurrence(occurrence_dates)
    end

    def presumed_income
      score = nil

      score_rating_several_models.each do |item|
        description = item.kind_description
        score = item if description.include? 'RENDA PRESUMIDA'
      end

      score.present? ? score.text : '0'
    end

    def lower_income_value
      filtred_income_text = presumed_income.gsub(/\./mi, '').split(/[^\d]/)
      formatted_income = filtred_income_text.reject(&:empty?)

      formatted_income.first&.to_i
    end

    def division_between_income_and_debits_value
      income = lower_income_value.to_i

      return unless debits_total_value != 0
      return debits_total_value if income.zero?

      debits_total_value / income
    end

    def division_between_income_and_protested_title_value
      income = lower_income_value.to_i

      return unless protested_titles_total_value != 0
      return protested_titles_total_value if income.zero?

      protested_titles_total_value / income
    end

    def age
      birth_date = identification_birth_date

      return unless birth_date.present? && valid_datetime?(birth_date)

      birth_date_datetime = birth_date.to_datetime

      today = Time.zone.today
      age = today.year - birth_date_datetime.year
      age -= 1 if today < birth_date_datetime + age.years

      age
    end

    private

    def valid_datetime?(value)
      value.to_datetime
      true
    rescue ArgumentError
      false
    end

    def format_values(values)
      values.map { |e| e.delete('.').to_f }
    end

    def calculate_days_since_last_occurrence(dates)
      formatted_dates = dates.map do |date|
        Date.parse(date) if valid_datetime? date
      end

      last_occurrence = formatted_dates.max

      return unless last_occurrence

      (Time.zone.today - last_occurrence).to_i
    end
  end
end
