# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_summaries
#
#  id         :bigint           not null, primary key
#  count      :integer
#  balance    :float
#  owner_type :string
#  owner_id   :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
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
