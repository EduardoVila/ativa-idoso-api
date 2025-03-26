# frozen_string_literal: true

# == Schema Information
#
# Table name: public_keys
#
#  id         :bigint           not null, primary key
#  algorithm  :string           not null
#  issuer     :string           not null
#  key        :string           not null
#  valid_from :datetime         not null
#  valid_to   :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PublicKey < ApplicationRecord
  validates :key, presence: true
  validates :issuer, presence: true, uniqueness: true
  validates :algorithm, presence: true
  validates :valid_from, presence: true
  validates :valid_to, presence: true
end
