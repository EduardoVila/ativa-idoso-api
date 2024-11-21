# frozen_string_literal: true

# == Schema Information
#
# Table name: request_logs
#
#  id         :uuid             not null, primary key
#  method     :string
#  path       :string
#  params     :string
#  headers    :string
#  body       :string
#  options    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class RequestLog < ApplicationRecord
  validates :method, presence: true
  validates :path, presence: true
  validates :headers, presence: true
end
