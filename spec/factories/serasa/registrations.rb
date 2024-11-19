# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_registrations
#
#  id                       :uuid             not null, primary key
#  document_number          :string
#  consumer_name            :string
#  mother_name              :string
#  birth_date               :string
#  status_registration      :string
#  status_date              :date
#  serasa_fintech_report_id :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
FactoryBot.define do
  factory :serasa_registration, class: 'Serasa::Registration' do
    document_number { Faker::CPF.numeric }
    consumer_name { Faker::Name.name }
    mother_name { Faker::Name.name }
    birth_date { Time.zone.today }
    status_registration { 'REGULAR' }

    fintech_report factory: :serasa_fintech_report
  end
end
