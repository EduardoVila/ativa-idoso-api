# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_updates
#
#  id                  :bigint           not null, primary key
#  capture_date        :datetime
#  content             :text
#  publish_date        :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  provenir_lawsuit_id :bigint           not null
#
# Indexes
#
#  index_provenir_update_lawsuit_id  (provenir_lawsuit_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_lawsuit_id => provenir_lawsuits.id)
#
module Provenir
  class Update < ApplicationRecord
    belongs_to :lawsuit,
               class_name: 'Provenir::Lawsuit',
               foreign_key: 'provenir_lawsuit_id',
               inverse_of: :updates
  end
end
