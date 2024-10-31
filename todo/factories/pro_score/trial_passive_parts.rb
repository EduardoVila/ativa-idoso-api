# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_passive_parts
#
#  id                      :bigint           not null, primary key
#  name                    :string
#  pro_score_trial_item_id :bigint           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
FactoryBot.define do
  factory :pro_score_trial_passive_part, class: 'ProScore::TrialPassivePart' do
    name { Faker::Name.name }

    trial_item { create :pro_score_trial_item }
  end
end
