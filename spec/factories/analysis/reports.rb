# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_reports
#
#  id                    :bigint           not null, primary key
#  approved              :boolean
#  cpfs                  :string           is an Array
#  disapproval_situation :integer
#  fee                   :float
#  payload               :string
#  status                :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  api_client_id         :bigint           not null
#
# Indexes
#
#  index_analysis_reports_on_api_client_id  (api_client_id)
#
# Foreign Keys
#
#  fk_rails_...  (api_client_id => api_clients.id)
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
