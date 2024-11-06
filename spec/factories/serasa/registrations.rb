# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_registration, class: 'Serasa::Registration' do
    document_number { Faker::CPF.numeric }
    consumer_name { Faker::Name.name }
    mother_name { Faker::Name.name }
    birth_date { Time.zone.today }
    status_registration { 'REGULAR' }

    fintech_report { create :serasa_fintech_report }
  end
end
