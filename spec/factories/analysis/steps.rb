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
    name { Faker::Name.name }
    command_class do
      [
        'ProScore::FamilyHoldingCommand',
        'ProScore::BouncedCheckCommand'
      ].sample
    end
    index_order { rand(1..1000) }
  end
end
