# frozen_string_literal: true

# == Schema Information
#
# Table name: response_logs
#
#  id            :uuid             not null, primary key
#  table         :string           not null
#  table_pointer :string
#  path          :string           not null
#  body          :string
#  status        :string           not null
#  method        :string
#  headers       :string
#  raw_data      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
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
