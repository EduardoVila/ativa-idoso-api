# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_authentications
#
#  id            :uuid             not null, primary key
#  token_type    :string
#  refresh_token :string
#  access_token  :string
#  expires_in    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
module ProScore
  class Authentication < ApplicationRecord
    def expired?
      (created_at.to_i + expires_in) < Time.zone.now.to_i
    end
  end
end
