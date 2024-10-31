# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_summaries
#
#  id         :bigint           not null, primary key
#  count      :integer
#  balance    :float
#  owner_type :string
#  owner_id   :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module Serasa
  class Summary < ApplicationRecord
    belongs_to :owner, polymorphic: true
  end
end
