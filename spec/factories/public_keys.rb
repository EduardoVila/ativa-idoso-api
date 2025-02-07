# frozen_string_literal: true

FactoryBot.define do
  factory :public_key do
    key { OpenSSL::PKey::RSA.new(2048).public_key.to_s }
    issuer { 'alpop-analysis' }
    algorithm { 'RS256' }
    valid_from { Time.now }
    valid_to { Time.now + 1.year }
  end
end
