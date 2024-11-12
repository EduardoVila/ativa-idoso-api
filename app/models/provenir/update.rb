# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_updates
#
#  id                  :bigint           not null, primary key
#  content             :text
#  publish_date        :datetime
#  capture_date        :datetime
#  provenir_lawsuit_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
module Provenir
  class Update < ApplicationRecord
    belongs_to :lawsuit,
               class_name: 'Provenir::Lawsuit',
               foreign_key: 'provenir_lawsuit_id',
               inverse_of: :updates
  end
end
