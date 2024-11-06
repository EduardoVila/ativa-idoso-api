# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_summary, class: 'Serasa::Summary' do
    count { rand(0..100) }
    balance { rand(0..1000) }

    owner { create :serasa_pefin }

    trait :pefin do
      owner { create :serasa_pefin }
    end

    trait :refin do
      owner { create :serasa_refin }
    end

    trait :notary do
      owner { create :serasa_notary }
    end
  end
end
