# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_related_people
#
#  id                                   :bigint           not null, primary key
#  name                                 :string
#  degree_of_kinship                    :string
#  cpf                                  :string
#  boa_vista_cadastral_qualification_id :bigint           not null
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#
FactoryBot.define do
  factory :boa_vista_related_person, class: 'BoaVista::RelatedPerson' do
    name { Faker::Name.name }
    degree_of_kinship { 'MAE' }

    boa_vista_cadastral_qualification
  end
end
