# frozen_string_literal: true

# == Schema Information
#
# Table name: public_keys
#
#  id         :bigint           not null, primary key
#  algorithm  :string           not null
#  issuer     :string           not null
#  key        :string           not null
#  valid_from :datetime         not null
#  valid_to   :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :public_key do
    key { OpenSSL::PKey::RSA.new(2048).public_key.to_s }
    issuer { 'alpop-analysis' }
    algorithm { 'RS256' }
    valid_from { Time.now }
    valid_to { Time.now + 1.year }
  end
end
