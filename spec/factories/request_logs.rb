# frozen_string_literal: true

# == Schema Information
#
# Table name: request_logs
#
#  id         :bigint           not null, primary key
#  method     :string
#  path       :string
#  params     :string
#  headers    :string
#  body       :string
#  options    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :request_log do
    sequence(:method) { |n| "Method #{n}" }
    sequence(:path) { |n| "Path #{n}" }
    sequence(:params) { |n| "Params #{n}" }
    sequence(:headers) { |n| "Headers #{n}" }
    sequence(:body) { |n| "Body #{n}" }
    sequence(:options) { |n| "Options #{n}" }
  end
end
