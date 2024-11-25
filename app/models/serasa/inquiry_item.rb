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
module Serasa
  class InquiryItem < ApplicationRecord
    belongs_to :inquiry,
               class_name: 'Serasa::Inquiry',
               foreign_key: 'serasa_inquiry_id',
               inverse_of: :items
  end
end
