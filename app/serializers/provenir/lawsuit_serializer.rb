# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_lawsuits
#
#  id                                  :bigint           not null, primary key
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
#  provenir_process_id                 :bigint           not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#
require_relative '../application_serializer'

module Provenir
  class LawsuitSerializer < ApplicationSerializer
    attributes :id, :trial_number, :uf, :court, :delivery_date,
               :area, :trial_class_name, :defendant, :disapproved

    def defendant
      object.defendant?
    end

    def disapproved
      object.disapproved?
    end

    def uf
      object.state
    end

    def trial_number
      object.lawsuit_number
    end

    def delivery_date
      object.notice_date
    end

    def area
      object.main_subject
    end

    def trial_class_name
      object.lawsuit_type
    end

    def court
      object.court_name
    end
  end
end
