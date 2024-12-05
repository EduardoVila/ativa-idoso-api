# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_predictions
#
#  id               :bigint           not null, primary key
#  cpf              :string
#  approved         :boolean
#  fee              :float
#  label            :string
#  input_data       :jsonb
#  analysis_item_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :analysis_prediction, class: 'Analysis::Prediction' do
    cpf { Faker::CPF.pretty }
    approved { [true, false].sample }
    label { Faker::Name.name }
    input_data { { 'key' => 'value' } }

    item factory: :analysis_item

    trait :approved do
      approved { true }
      fee { Faker::Number.decimal(l_digits: 2) }
    end

    trait :unapproved do
      approved { false }
      fee { nil }
    end
  end
end
