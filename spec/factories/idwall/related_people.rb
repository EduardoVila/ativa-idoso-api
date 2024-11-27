# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_related_people
#
#  id               :bigint           not null, primary key
#  cpf              :string
#  name             :string
#  kind             :string
#  idwall_report_id :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :idwall_related_person, class: 'Idwall::RelatedPerson' do
    cpf { Faker::CPF.pretty }
    name { Faker::Name.name }
    kind { 'FAMILIA' }

    idwall_report
  end
end
