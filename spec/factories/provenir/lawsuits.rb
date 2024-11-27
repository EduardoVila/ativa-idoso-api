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
FactoryBot.define do
  factory :provenir_lawsuit, class: 'Provenir::Lawsuit' do
    lawsuit_number { Faker::Number.number(digits: 10).to_s }
    lawsuit_type { Faker::Lorem.word }
    main_subject { Faker::Lorem.word }
    court_name { Faker::Lorem.word }
    court_level { Faker::Lorem.word }
    court_type { Faker::Lorem.word }
    court_district { Faker::Lorem.word }
    judging_body { Faker::Lorem.word }
    state { Faker::Address.state_abbr }
    status { Faker::Lorem.word }
    lawsuit_host_service { Faker::Lorem.word }
    inferred_cnj_subject_name { Faker::Lorem.word }
    inferred_cnj_subject_number { Faker::Lorem.word }
    inferred_cnj_procedure_type_name { Faker::Lorem.word }
    inferred_broad_cnj_subject_name { Faker::Lorem.word }
    inferred_broad_cnj_subject_number { Faker::Lorem.word }
    number_of_volumes { Faker::Number.decimal(l_digits: 1) }
    number_of_pages { Faker::Number.decimal(l_digits: 3) }
    value { Faker::Number.decimal(l_digits: 5) }
    res_judicata_date { Faker::Date.backward }
    close_date { Faker::Date.backward }
    redistribution_date { Faker::Date.backward }
    publication_date { Faker::Date.backward }
    notice_date { Faker::Date.backward }
    last_movement_date { Faker::Date.backward }
    capture_date { Faker::Date.backward }
    last_update { Faker::Date.backward }
    number_of_parties { Faker::Number.number(digits: 2) }
    number_of_updates { Faker::Number.number(digits: 3) }
    law_suit_age { Faker::Number.number(digits: 4) }
    average_number_of_updates_per_month { Faker::Number.number(digits: 1) }
    reason_for_concealed_data { Faker::Number.number(digits: 1) }

    process factory: :provenir_process

    trait :with_banned_keywords do
      main_subject { 'crime' }
    end
  end
end
