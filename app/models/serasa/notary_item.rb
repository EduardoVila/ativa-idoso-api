# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_notary_items
#
#  id               :bigint           not null, primary key
#  amount           :float
#  city             :string
#  federal_unit     :string
#  occurrence_date  :date
#  office_name      :string
#  office_number    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  serasa_notary_id :bigint           not null
#
# Indexes
#
#  index_serasa_notary_items_on_serasa_notary_id  (serasa_notary_id)
#
# Foreign Keys
#
#  fk_rails_...  (serasa_notary_id => serasa_notaries.id)
#
module Serasa
  class NotaryItem < ApplicationRecord
    belongs_to :notary,
               class_name: 'Serasa::Notary',
               foreign_key: 'serasa_notary_id',
               inverse_of: :items
  end
end
