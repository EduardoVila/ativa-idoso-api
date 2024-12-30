# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_cpfs
#
#  id                      :bigint           not null, primary key
#  gender                  :string
#  number                  :string
#  birth_date              :string
#  source                  :string
#  name                    :string
#  income                  :string
#  income_tax_situation    :string
#  cpf_cadastral_situation :string
#  cpf_subscription_date   :string
#  cpf_verifying_digit     :string
#  year_of_death           :string
#  social_name             :string
#  idwall_report_id        :bigint           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
module Idwall
  class CPF < ApplicationRecord
    belongs_to :idwall_report, class_name: 'Idwall::Report'

    validates :idwall_report_id, uniqueness: true
  end
end
