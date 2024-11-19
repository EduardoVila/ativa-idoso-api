# frozen_string_literal: true

# == Schema Information
#
# Table name: lawsuit_banned_keywords
#
#  id                  :uuid             not null, primary key
#  keyword             :string
#  litigation_category :integer          default("criminal")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :lawsuit_banned_keyword, class: 'Lawsuit::BannedKeyword' do
    keyword { 'crime' }

    trait :criminal do
      keyword { 'crime' }
      litigation_category { :criminal }
    end

    trait :lease_agreement do
      keyword { 'locacao' }
      litigation_category { :lease_agreement }
    end

    trait :execution do
      keyword { 'execucao' }
      litigation_category { :execution }
    end

    trait :warranty do
      keyword { 'alienacao' }
      litigation_category { :warranty }
    end

    trait :real_estate do
      keyword { 'agua' }
      litigation_category { :real_estate }
    end

    trait :negotiable_instrument do
      keyword { 'cheques' }
      litigation_category { :negotiable_instrument }
    end

    # Default trait
    criminal
  end
end
