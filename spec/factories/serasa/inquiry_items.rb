# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_inquiry_item, class: 'Serasa::InquiryItem' do
    occurrence_date { Time.zone.today }
    days_quantity { rand(1..1000) }

    inquiry factory: :serasa_inquiry
  end
end
