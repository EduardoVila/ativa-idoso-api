# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_summaries
#
#  id         :bigint           not null, primary key
#  balance    :float
#  count      :integer
#  owner_type :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :bigint
#
# Indexes
#
#  index_serasa_summaries_on_owner  (owner_type,owner_id) UNIQUE
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
