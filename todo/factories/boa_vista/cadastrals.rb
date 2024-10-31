# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_cadastral, class: 'BoaVista::Cadastral' do
    raw_data { '{}' }

    consumer { create :score }
  end
end
