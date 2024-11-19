# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_inquiries
#
#  id             :uuid             not null, primary key
#  serasa_fact_id :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :serasa_inquiry, class: 'Serasa::Inquiry' do
    fact factory: :serasa_fact
  end
end
