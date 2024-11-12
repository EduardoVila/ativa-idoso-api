# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_authentications
#
#  id           :uuid             not null, primary key
#  access_token :string
#  expires_in   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :serasa_authentication, class: 'Serasa::Authentication' do
    access_token { Faker::Internet.device_token }
    expires_in { (Time.zone.now + 60.minutes).to_time.to_i }

    trait :expired do
      expires_in { (Time.zone.now - 60.minutes).to_time.to_i }
    end
  end
end
