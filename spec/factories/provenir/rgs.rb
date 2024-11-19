# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_rgs
#
#  id                                        :uuid             not null, primary key
#  number                                    :string
#  document_last4_digits                     :string
#  creation_date                             :datetime
#  last_update_date                          :datetime
#  provenir_extended_document_information_id :uuid             not null
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#
FactoryBot.define do
  factory :provenir_rg, class: 'Provenir::Rg' do
    document_last4_digits { Faker::Number.number(digits: 4).to_s }
    creation_date { Faker::Date.in_date_period }
    last_update_date { Faker::Date.in_date_period }

    extended_document_information(
      factory: :provenir_extended_document_information
    )
  end
end
