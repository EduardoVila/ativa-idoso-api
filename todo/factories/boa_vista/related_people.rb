# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_related_person, class: 'BoaVista::RelatedPerson' do
    name { Faker::Name.name }
    degree_of_kinship { 'MAE' }

    boa_vista_cadastral_qualification
  end
end
