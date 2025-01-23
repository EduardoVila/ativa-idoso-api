# frozen_string_literal: true

class PublicKey < ApplicationRecord
  validates :key, presence: true
  validates :issuer, presence: true, uniqueness: true
  validates :algorithm, presence: true
  validates :valid_from, presence: true
  validates :valid_to, presence: true
end
