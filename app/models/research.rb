# frozen_string_literal: true

# == Schema Information
#
# Table name: researches
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Research < ApplicationRecord
  has_many :questions, dependent: :destroy

  validates :title, presence: true
end
