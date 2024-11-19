# frozen_string_literal: true

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
