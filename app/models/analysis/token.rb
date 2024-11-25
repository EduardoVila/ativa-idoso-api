# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_tokens
#
#  id           :bigint           not null, primary key
#  access_token :string
#  token_type   :string
#  expires_in   :integer
#  scope        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
module Analysis
  class Token < ApplicationRecord
    def expired?
      (created_at.to_i + expires_in) < Time.now.to_i
    end
  end
end
