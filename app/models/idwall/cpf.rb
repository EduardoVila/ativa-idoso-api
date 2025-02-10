# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_cpfs
#
#  id                      :bigint           not null, primary key
#  birth_date              :string
#  cpf_cadastral_situation :string
#  cpf_subscription_date   :string
#  cpf_verifying_digit     :string
#  gender                  :string
#  income                  :string
#  income_tax_situation    :string
#  name                    :string
#  number                  :string
#  social_name             :string
#  source                  :string
#  year_of_death           :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  idwall_report_id        :bigint           not null
#
# Indexes
#
#  index_idwall_cpfs_on_idwall_report_id  (idwall_report_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (idwall_report_id => idwall_reports.id)
#
module Idwall
  class CPF < ApplicationRecord
    belongs_to :idwall_report, class_name: 'Idwall::Report'

    validates :idwall_report_id, uniqueness: true
  end
end
