# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_summaries
#
#  id         :bigint           not null, primary key
#  balance    :float
#  count      :integer
#  owner_type :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :bigint
#
# Indexes
#
#  index_serasa_summaries_on_owner  (owner_type,owner_id) UNIQUE
#
module Serasa
  class Summary < ApplicationRecord
    belongs_to :owner, polymorphic: true

    validates :owner_id, uniqueness: { scope: :owner_type }
  end
end
