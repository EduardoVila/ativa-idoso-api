# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_basic_data
#
#  id                                   :bigint           not null, primary key
#  age                                  :integer
#  birth_country                        :string
#  birth_date                           :datetime
#  chinese_sign                         :string
#  creation_date                        :datetime
#  father_name                          :string
#  first_and_last_name_uniqueness_score :integer
#  first_name_uniqueness_score          :integer
#  gender                               :string
#  has_obit_indication                  :boolean
#  last_update_date                     :datetime
#  marital_status_data                  :string
#  mother_name                          :string
#  name                                 :string
#  name_uniqueness_score                :integer
#  name_word_count                      :integer
#  number_of_full_name_namesakes        :integer
#  tax_id_country                       :string
#  tax_id_fiscal_region                 :string
#  tax_id_number                        :string
#  tax_id_origin                        :string
#  tax_id_status                        :string
#  tax_id_status_date                   :datetime
#  tax_id_status_registration_date      :datetime
#  zodiac_sign                          :string
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  provenir_big_data_corp_id            :bigint           not null
#
# Indexes
#
#  index_provenir_basic_datum_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
#
FactoryBot.define do
  factory :provenir_basic_datum, class: 'Provenir::BasicDatum' do
    tax_id_number { Faker::CPF.pretty }
    tax_id_country { Faker::Address.country }
    name { Faker::Name.name }
    gender { %w[M F].sample }
    name_word_count { Faker::Number.number(digits: 1) }
    number_of_full_name_namesakes { Faker::Number.number(digits: 1) }
    name_uniqueness_score { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    first_name_uniqueness_score do
      Faker::Number.decimal(l_digits: 1, r_digits: 2)
    end
    first_and_last_name_uniqueness_score do
      Faker::Number.decimal(l_digits: 1, r_digits: 2)
    end
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }
    age { Faker::Number.number(digits: 2) }
    zodiac_sign { Faker::Creature::Animal.name }
    chinese_sign { Faker::Creature::Animal.name }
    birth_country { Faker::Address.country }
    mother_name { Faker::Name.name }
    father_name { Faker::Name.name }
    marital_status_data { Faker::Lorem.word }
    tax_id_status { Faker::Lorem.word }
    tax_id_origin { Faker::Lorem.word }
    tax_id_fiscal_region { Faker::Lorem.word }
    has_obit_indication { Faker::Boolean.boolean }
    tax_id_status_date { Faker::Date.forward }
    tax_id_status_registration_date { Faker::Date.backward }
    creation_date { Faker::Date.backward }
    last_update_date { Faker::Date.backward }

    big_data_corp factory: :provenir_big_data_corp
  end
end
