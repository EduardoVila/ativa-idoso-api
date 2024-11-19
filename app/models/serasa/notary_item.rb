# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_notary_items
#
#  id               :uuid             not null, primary key
#  occurrence_date  :date
#  amount           :float
#  office_number    :string
#  office_name      :string
#  city             :string
#  federal_unit     :string
#  serasa_notary_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
module Serasa
  class NotaryItem < ApplicationRecord
    belongs_to :notary,
               class_name: 'Serasa::Notary',
               foreign_key: 'serasa_notary_id',
               inverse_of: :items
  end
end
