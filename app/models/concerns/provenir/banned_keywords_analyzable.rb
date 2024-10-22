# frozen_string_literal: true

module Provenir
  module BannedKeywordsAnalyzable
    extend ActiveSupport::Concern

    included do
      def banned_keywords_present?
        subject_matters.any? do |string|
          next if string.blank?

          words_array = string.split.uniq

          words_array.any? { |word| keyword_found?(word) }
        end
      end
    end

    private

    def subject_matters
      @subject_matters ||= [
        main_subject, lawsuit_type, inferred_cnj_subject_name,
        inferred_broad_cnj_subject_name, inferred_cnj_procedure_type_name,
        court_type, judging_body
      ]
    end

    # This method is responsible to query the banned keywords from the lawsuits.
    def banned_keywords
      @banned_keywords ||= ::Lawsuit::BannedKeyword.all_banned_keywords
    end

    # This method is responsible to check if the keyword is present in the
    # banned keywords of the lawsuits.
    def keyword_found?(keyword)
      keyword.blank? ? false : banned_keywords.any?(formatted_string(keyword))
    end
  end
end
