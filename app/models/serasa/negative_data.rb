# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_negative_data
#
#  id                       :uuid             not null, primary key
#  serasa_fintech_report_id :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
module Serasa
  class NegativeData < ApplicationRecord
    belongs_to :fintech_report,
               class_name: 'Serasa::FintechReport',
               foreign_key: 'serasa_fintech_report_id',
               inverse_of: :negative_data

    has_one :pefin,
            class_name: 'Serasa::Pefin',
            dependent: :destroy,
            foreign_key: 'serasa_negative_data_id',
            inverse_of: :negative_data

    has_one :refin,
            class_name: 'Serasa::Refin',
            dependent: :destroy,
            foreign_key: 'serasa_negative_data_id',
            inverse_of: :negative_data

    has_one :notary,
            class_name: 'Serasa::Notary',
            dependent: :destroy,
            foreign_key: 'serasa_negative_data_id',
            inverse_of: :negative_data

    has_one :check,
            class_name: 'Serasa::Check',
            dependent: :destroy,
            foreign_key: 'serasa_negative_data_id',
            inverse_of: :negative_data

    accepts_nested_attributes_for :pefin
    accepts_nested_attributes_for :refin
    accepts_nested_attributes_for :notary
    accepts_nested_attributes_for :check

    delegate :count, :total_value, :maximum_value, :minimum_value, :items,
             :days_since_the_last_occurence, to: :pefin, prefix: true

    delegate :count, :total_value, :maximum_value, :minimum_value, :items,
             :days_since_the_last_occurence, to: :refin, prefix: true

    delegate :count, :total_value, :maximum_value, :minimum_value,
             :days_since_the_last_occurence, to: :notary, prefix: true

    delegate :count, to: :check, prefix: true

    def debits_count
      pefin_count + refin_count
    end

    def debits
      [pefin.items, refin.items].flatten
    end

    def notaries_count
      notary_count
    end

    def notaries
      notary.items
    end

    def approved?
      pefin.approved? && refin.approved?
    end
  end
end
