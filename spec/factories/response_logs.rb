# frozen_string_literal: true

FactoryBot.define do
  factory :response_log do
    sequence(:table) { |n| "table #{n}" }
    sequence(:table_pointer) { |n| "table pointer #{n}" }
    sequence(:path) { |n| "Path #{n}" }
    sequence(:body) { |n| "Body #{n}" }
    sequence(:status) { |n| "Status #{n}" }
    sequence(:method) { |n| "Method #{n}" }
    sequence(:headers) { |n| "Headers #{n}" }
    sequence(:raw_data) { |n| "Raw_data #{n}" }
  end
end
