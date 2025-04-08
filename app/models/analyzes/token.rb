# frozen_string_literal: true

# == Schema Information
#
# Table name: analyzes_tokens
#
#  id           :bigint           not null, primary key
#  access_token :string
#  expires_in   :integer
#  scope        :string
#  token_type   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
module Analyzes
  class Token < ApplicationRecord
    def expired?
      (created_at.to_i + expires_in) < Time.now.to_i
    end
  end
end
