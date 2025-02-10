# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_extended_phones
#
#  id                           :bigint           not null, primary key
#  newest_phone_passage_date    :datetime
#  oldest_phone_passage_date    :datetime
#  total_active_phones          :integer
#  total_bad_phone_passages     :integer
#  total_last12_months_passages :integer
#  total_last16_months_passages :integer          default(0)
#  total_last18_months_passages :integer
#  total_last3_months_passages  :integer
#  total_last6_months_passages  :integer
#  total_personal_phones        :integer
#  total_phone_passages         :integer
#  total_phones                 :integer
#  total_unique_phones          :integer
#  total_work_phones            :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  provenir_big_data_corp_id    :bigint           not null
#
# Indexes
#
#  index_provenir_extended_phone_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
#
module Provenir
  class ExtendedPhone < ApplicationRecord
    belongs_to :big_data_corp,
               class_name: 'Provenir::BigDataCorp',
               foreign_key: 'provenir_big_data_corp_id',
               inverse_of: :extended_phone

    has_many :phones,
             class_name: 'Provenir::Phone',
             foreign_key: 'provenir_extended_phone_id',
             inverse_of: :extended_phone,
             dependent: :destroy

    validates :provenir_big_data_corp_id, uniqueness: true

    accepts_nested_attributes_for :phones
  end
end
