# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_inquiry_items
#
#  id                  :bigint           not null, primary key
#  occurrence_date     :date
#  days_quantity       :integer
#  segment_description :string
#  serasa_inquiry_id   :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :serasa_inquiry_item, class: 'Serasa::InquiryItem' do
    occurrence_date { Time.zone.today }
    days_quantity { rand(1..1000) }

    inquiry factory: :serasa_inquiry
  end
end
