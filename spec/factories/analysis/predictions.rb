# frozen_string_literal: true

FactoryBot.define do
  factory :analysis_prediction, class: 'Analysis::Prediction' do
    cpf { Faker::CPF.pretty }
    approved { [true, false].sample }
    fee { Faker::Number.decimal(l_digits: 2) }
    label { Faker::Name.name }
    input_data { { 'key' => 'value' } }

    item factory: :analysis_item
  end
end
