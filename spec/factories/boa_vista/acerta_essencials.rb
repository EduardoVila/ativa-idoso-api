# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_acerta_essencial, class: 'BoaVista::AcertaEssencial' do
    cpf { Faker::CPF.pretty }
    credit_type { :CC }
    raw_data { '{}' }

    consumer factory: :analysis_item
  end
end
