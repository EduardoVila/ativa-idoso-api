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
    fee { Faker::Number.decimal(l_digits: 2) }
    label { Faker::Name.name }
    input_data { { 'key' => 'value' } }

    item factory: :analysis_item
  end
end
