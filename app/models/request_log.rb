# frozen_string_literal: true

class RequestLog < ApplicationRecord
  validates :method, presence: true
  validates :path, presence: true
  validates :headers, presence: true
end
