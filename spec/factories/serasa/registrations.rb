# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_registrations
#
#  id                       :bigint           not null, primary key
#  birth_date               :string
#  consumer_name            :string
#  document_number          :string
#  mother_name              :string
#  status_date              :date
#  status_registration      :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  serasa_fintech_report_id :bigint           not null
#
# Indexes
#
#  index_serasa_registrations_on_serasa_fintech_report_id  (serasa_fintech_report_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_fintech_report_id => serasa_fintech_reports.id)
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
