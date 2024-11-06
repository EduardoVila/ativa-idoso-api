# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_summary, class: 'Serasa::Summary' do
    count { rand(0..100) }
    balance { rand(0..1000) }

    owner factory: :serasa_pefin

    trait :pefin do
      owner factory: :serasa_pefin
    end

    trait :refin do
      owner factory: :serasa_refin
    end

    trait :notary do
      owner factory: :serasa_notary
    end
  end
end
