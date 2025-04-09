# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_steps
#
#  id            :bigint           not null, primary key
#  name          :string
#  command_class :string
#  index_order   :integer
#  enabled       :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :analysis_step, class: 'Analysis::Step' do
    name do
      %w[
        pro_score_bounced_checks
        provenir_big_data_corp
        boa_vista_acerta_essencial
        pre_predictions
        predictions
      ].sample
    end
    command_class do
      %w[
        ProScore::BouncedCheckCommand
        Provenir::BigDataCorpCommand
        BoaVista::AcertaEssencialCommand
        PrePredictionCommand
        PredictionCommand
      ].sample
    end
    index_order { rand(1..1000) }
    enabled { true }

    trait :disabled do
      enabled { false }
    end
  end
end
