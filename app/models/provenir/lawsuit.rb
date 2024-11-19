# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_lawsuits
#
#  id                                  :uuid             not null, primary key
#  lawsuit_number                      :string
#  lawsuit_type                        :string
#  main_subject                        :text
#  court_name                          :string
#  court_level                         :string
#  court_type                          :string
#  court_district                      :string
#  judging_body                        :string
#  state                               :string
#  status                              :string
#  lawsuit_host_service                :string
#  inferred_cnj_subject_name           :string
#  inferred_cnj_subject_number         :string
#  inferred_cnj_procedure_type_name    :string
#  inferred_broad_cnj_subject_name     :string
#  inferred_broad_cnj_subject_number   :string
#  number_of_volumes                   :integer
#  number_of_pages                     :integer
#  value                               :string
#  res_judicata_date                   :datetime
#  close_date                          :datetime
#  redistribution_date                 :datetime
#  publication_date                    :datetime
#  notice_date                         :datetime
#  last_movement_date                  :datetime
#  capture_date                        :datetime
#  last_update                         :datetime
#  number_of_parties                   :integer
#  number_of_updates                   :integer
#  law_suit_age                        :integer
#  average_number_of_updates_per_month :float
#  reason_for_concealed_data           :string
#  provenir_process_id                 :uuid             not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#

require_relative '../concerns/provenir/banned_keywords_analyzable'
require_relative '../concerns/provenir/defendant_analyzable'
require_relative '../concerns/provenir/disapproval_analyzable'
require_relative '../concerns/provenir/lawsuit_exceptionable'
require_relative '../concerns/name_comparable'

module Provenir
  class Lawsuit < ApplicationRecord
    include DisapprovalAnalyzable
    include DefendantAnalyzable
    include BannedKeywordsAnalyzable
    include LawsuitExceptionable
    include NameComparable

    belongs_to :process,
               class_name: 'Provenir::Process',
               foreign_key: 'provenir_process_id',
               inverse_of: :lawsuits

    has_many :decisions,
             class_name: 'Provenir::Decision',
             foreign_key: 'provenir_lawsuit_id',
             inverse_of: :lawsuit,
             dependent: :destroy

    has_many :parties,
             class_name: 'Provenir::Party',
             foreign_key: 'provenir_lawsuit_id',
             inverse_of: :lawsuit,
             dependent: :destroy

    has_many :petitions,
             class_name: 'Provenir::Petition',
             foreign_key: 'provenir_lawsuit_id',
             inverse_of: :lawsuit,
             dependent: :destroy

    has_many :updates,
             class_name: 'Provenir::Update',
             foreign_key: 'provenir_lawsuit_id',
             inverse_of: :lawsuit,
             dependent: :destroy

    alias_attribute :type, :lawsuit_type
    alias_attribute :number, :lawsuit_number

    accepts_nested_attributes_for :decisions, :parties, :petitions, :updates
  end
end
