# frozen_string_literal: true

# == Schema Information
#
# Table name: response_logs
#
#  id            :uuid             not null, primary key
#  table         :string           not null
#  table_pointer :string
#  path          :string           not null
#  body          :string
#  status        :string           not null
#  method        :string
#  headers       :string
#  raw_data      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class ResponseLog < ApplicationRecord
  validates :table, presence: true
  validates :path, presence: true
  validates :status, presence: true
end
