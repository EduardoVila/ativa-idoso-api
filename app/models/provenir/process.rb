# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_processes
#
#  id                        :uuid             not null, primary key
#  lawsuits_total            :integer
#  defendant_lawsuits_total  :integer
#  plaintiff_lawsuits_total  :integer
#  provenir_big_data_corp_id :uuid             not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
module Provenir
  class Process < ApplicationRecord
    belongs_to :big_data_corp,
               class_name: 'Provenir::BigDataCorp',
               foreign_key: 'provenir_big_data_corp_id',
               inverse_of: :process

    has_many :lawsuits,
             class_name: 'Provenir::Lawsuit',
             foreign_key: 'provenir_process_id',
             inverse_of: :process,
             dependent: :destroy

    accepts_nested_attributes_for :lawsuits
  end
end
