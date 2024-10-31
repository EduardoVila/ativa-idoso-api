# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_inquiry, class: 'Serasa::Inquiry' do
    fact { create :serasa_fact }
  end
end
