# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_inquiry_items
#
#  id                  :bigint           not null, primary key
#  days_quantity       :integer
#  occurrence_date     :date
#  segment_description :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  serasa_inquiry_id   :bigint           not null
#
# Indexes
#
#  index_serasa_inquiry_items_on_serasa_inquiry_id  (serasa_inquiry_id)
#
# Foreign Keys
#
#  fk_rails_...  (serasa_inquiry_id => serasa_inquiries.id)
#
FactoryBot.define do
  factory :serasa_inquiry_item, class: 'Serasa::InquiryItem' do
    occurrence_date { Time.zone.today }
    days_quantity { rand(1..1000) }

    inquiry factory: :serasa_inquiry
  end
end
