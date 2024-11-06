# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_inquiry, class: 'Serasa::Inquiry' do
    fact factory: :serasa_fact
  end
end
