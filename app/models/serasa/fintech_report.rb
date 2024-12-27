# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_fintech_reports
#
#  id               :bigint           not null, primary key
#  raw_data         :string
#  analysis_item_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
module Serasa
  class FintechReport < ApplicationRecord
    include AssociationAliasable

    ASSOCIATION_ALIASES = {
      facts: :fact
    }.freeze

    belongs_to :owner,
               class_name: '::Analysis::Item',
               inverse_of: :serasa_fintech_report,
               foreign_key: 'analysis_item_id'

    has_one :registration,
            class_name: 'Serasa::Registration',
            dependent: :destroy,
            foreign_key: 'serasa_fintech_report_id',
            inverse_of: :fintech_report

    has_one :negative_data,
            class_name: 'Serasa::NegativeData',
            dependent: :destroy,
            foreign_key: 'serasa_fintech_report_id',
            inverse_of: :fintech_report

    has_one :score,
            class_name: 'Serasa::Score',
            dependent: :destroy,
            foreign_key: 'serasa_fintech_report_id',
            inverse_of: :fintech_report

    has_one :fact,
            class_name: 'Serasa::Fact',
            dependent: :destroy,
            foreign_key: 'serasa_fintech_report_id',
            inverse_of: :fintech_report

    validates :analysis_item_id, uniqueness: true

    accepts_nested_attributes_for :registration
    accepts_nested_attributes_for :score
    accepts_nested_attributes_for :negative_data
    accepts_nested_attributes_for :fact

    alias facts fact

    # Adds suport for creating fact associations via `facts_attributes`
    # This is in addition to `fact_attributes=value` method provided by
    # `accepts_nested_attributes_for :fact`
    # Required to import data from Serasa API
    def facts_attributes=(params)
      self.fact_attributes = params
    end
  end
end
