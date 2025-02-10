# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_inquiries
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  serasa_fact_id :bigint           not null
#
# Indexes
#
#  index_serasa_inquiries_on_serasa_fact_id  (serasa_fact_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_fact_id => serasa_facts.id)
#
FactoryBot.define do
  factory :serasa_inquiry, class: 'Serasa::Inquiry' do
    fact factory: :serasa_fact
  end
end
