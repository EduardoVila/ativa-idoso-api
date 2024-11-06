# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_notary, class: 'Serasa::Notary' do
    negative_data { create :serasa_negative_data }
  end
end
