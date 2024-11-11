# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_petition, class: 'Provenir::Petition' do
    lawsuit factory: :provenir_lawsuit
  end
end
