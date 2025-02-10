# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_previous_queries
#
#  id                            :bigint           not null, primary key
#  currency                      :string
#  date                          :string
#  informant                     :string
#  occurrence_type               :string
#  product                       :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  value                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_previous_queries_on_acerta_essencial_id  (boa_vista_acerta_essencial_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
module BoaVista
  class PreviousQuery < ApplicationRecord
    belongs_to :boa_vista_acerta_essencial,
               class_name: 'BoaVista::AcertaEssencial',
               inverse_of: :previous_queries
  end
end
