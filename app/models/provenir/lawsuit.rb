# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_lawsuits
#
#  id                                  :bigint           not null, primary key
#  average_number_of_updates_per_month :float
#  capture_date                        :datetime
#  close_date                          :datetime
#  court_district                      :string
#  court_level                         :string
#  court_name                          :string
#  court_type                          :string
#  inferred_broad_cnj_subject_name     :string
#  inferred_broad_cnj_subject_number   :string
#  inferred_cnj_procedure_type_name    :string
#  inferred_cnj_subject_name           :string
#  inferred_cnj_subject_number         :string
#  judging_body                        :string
#  last_movement_date                  :datetime
#  last_update                         :datetime
#  law_suit_age                        :integer
#  lawsuit_host_service                :string
#  lawsuit_number                      :string
#  lawsuit_type                        :string
#  main_subject                        :text
#  notice_date                         :datetime
#  number_of_pages                     :integer
#  number_of_parties                   :integer
#  number_of_updates                   :integer
#  number_of_volumes                   :integer
#  publication_date                    :datetime
#  reason_for_concealed_data           :string
#  redistribution_date                 :datetime
#  res_judicata_date                   :datetime
#  state                               :string
#  status                              :string
#  value                               :string
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  provenir_process_id                 :bigint           not null
#
# Indexes
#
#  index_provenir_lawsuit_process_id  (provenir_process_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_process_id => provenir_processes.id)
#
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

    alias_method :defendant, :defendant?
    alias_method :disapproved, :disapproved?

    accepts_nested_attributes_for :decisions, :parties, :petitions, :updates
  end
end
