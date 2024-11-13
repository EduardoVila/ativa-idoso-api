# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_cpfs
#
#  id                      :uuid             not null, primary key
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
#  idwall_report_id        :uuid             not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
module Idwall
  class CPF < ApplicationRecord
    belongs_to :idwall_report, class_name: 'Idwall::Report'
  end
end
