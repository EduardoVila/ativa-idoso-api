# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_predictions
#
#  id               :bigint           not null, primary key
#  approved         :boolean
#  cpf              :string
#  fee              :float
#  input_data       :jsonb
#  label            :string
#  raw_data         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  analysis_item_id :bigint           not null
#
# Indexes
#
#  index_analysis_predictions_on_analysis_item_id  (analysis_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (analysis_item_id => analysis_items.id)
#
FactoryBot.define do
  factory :analysis_prediction, class: 'Analysis::Prediction' do
    cpf { Faker::CPF.pretty }
    approved { [true, false].sample }
    label { %w[human_analyzed multi_softmax].sample }
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
