# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_reports
#
#  id                    :uuid             not null, primary key
#  cpfs                  :string           is an Array
#  status                :integer
#  fee                   :float
#  approved              :boolean
#  disapproval_situation :integer
#  api_client_id         :uuid             not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
require 'faker'
require 'cpf_cnpj'

FactoryBot.define do
  factory :analysis_report, class: 'Analysis::Report' do
    cpfs { [Faker::CPF.pretty, Faker::CPF.pretty] }
    status { %i[todo wip done not_found error].sample }

    api_client factory: :api_client

    trait :processed do
      after(:create) do |analysis_report|
        fee = [5.5, 6.5, 7.5, 8.5, 9.5].sample
        analysis_report.fee = (fee > 10.5 ? 12.0 : fee) + 2 # adding 2% to preserver our cash
        analysis_report.approved = true
      end
    end

    # This trait is used to create a analysis report with a random status
    Analysis::Report.statuses.each_key do |name|
      trait name.to_sym do
        status { name }
      end
    end
  end
end
