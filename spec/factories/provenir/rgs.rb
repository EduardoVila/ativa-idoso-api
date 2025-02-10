# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_rgs
#
#  id                                        :bigint           not null, primary key
#  creation_date                             :datetime
#  document_last4_digits                     :string
#  last_update_date                          :datetime
#  number                                    :string
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  provenir_extended_document_information_id :bigint           not null
#
# Indexes
#
#  index_big_data_rg_extended_document_information_id  (provenir_extended_document_information_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_extended_document_information_id => provenir_extended_document_informations.id)
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
