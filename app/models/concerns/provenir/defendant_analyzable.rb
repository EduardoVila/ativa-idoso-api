# frozen_string_literal: true

module Provenir
  module DefendantAnalyzable
    extend ActiveSupport::Concern

    included do
      def defendant?
        defendant_by_cpf? || defendant_by_name?
      end
    end

    private

    # This method is responsible to check if the searched tax_id_number
    # (a.k.a. CPF) is present in the lawsuit parties as polarity passive.
    def defendant_by_cpf?
      person_data_and_polarities.any? do |party_object|
        party_object.polarity == 'PASSIVE' &&
          party_object.party_doc == basic_datum_tax_id_number
      end
    end

    def defendant_by_name?
      defendant_name, non_defendant_name = nil

      person_data_and_polarities.each do |party_object|
        party_name = party_object.name
        polarity = party_object.polarity

        defendant_name = party_defendant(
          polarity, defendant_name, party_name
        )

        non_defendant_name = party_non_defendant(
          polarity, non_defendant_name, party_name
        )
      end

      return false if defendant_name.blank? && non_defendant_name.blank?

      name1_closer_to_compared_name?(
        compared_name, defendant_name, non_defendant_name
      )
    end

    def person_data_and_polarities
      @person_data_and_polarities ||= parties
        .select(:name, :polarity, :party_doc)
    end

    # This method is responsible to check if the distance between the compared
    # name and the party name is lower or equal to the distance between the
    # compared name and the defendant name.
    def party_defendant(polarity, defendant_name, party_name)
      return defendant_name if %w[ACTIVE NEUTRAL].include?(polarity)

      if defendant_name.blank? ||
         name1_closer_to_compared_name?(
           compared_name, party_name, defendant_name
         )

        return party_name
      end

      defendant_name
    end

    def party_non_defendant(polarity, non_defendant_name, party_name)
      return non_defendant_name if %w[PASSIVE].include?(polarity)

      if non_defendant_name.blank? ||
         name1_closer_to_compared_name?(
           compared_name, party_name, non_defendant_name
         )

        return party_name
      end

      non_defendant_name
    end

    def compared_name
      @compared_name ||= process.big_data_corp.basic_datum.name
    end

    def basic_datum_tax_id_number
      @basic_datum_tax_id_number ||= process.big_data_corp.basic_datum
        .tax_id_number
    end
  end
end
