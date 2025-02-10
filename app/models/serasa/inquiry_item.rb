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
module Serasa
  class InquiryItem < ApplicationRecord
    belongs_to :inquiry,
               class_name: 'Serasa::Inquiry',
               foreign_key: 'serasa_inquiry_id',
               inverse_of: :items
  end
end
