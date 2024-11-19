# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_authentications
#
#  id           :uuid             not null, primary key
#  access_token :string
#  expires_in   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
module Serasa
  class Authentication < ApplicationRecord
    def expired?
      formatted_date = Time.zone.at(expires_in.to_i).to_datetime

      formatted_date < (Time.zone.now + 5.minutes)
    end
  end
end
