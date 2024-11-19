# frozen_string_literal: true

class ResponseLog < ApplicationRecord
  validates :table, presence: true
  validates :path, presence: true
  validates :status, presence: true
end
