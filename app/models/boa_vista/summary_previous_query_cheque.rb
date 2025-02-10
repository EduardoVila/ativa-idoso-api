# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_summary_previous_query_cheques
#
#  id                            :bigint           not null, primary key
#  day                           :string
#  day_value                     :string
#  document_number               :string
#  document_type                 :string
#  pre_dated                     :string
#  pre_dated_value               :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  total                         :string
#  value                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_summary_previous_query_cheques_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
module BoaVista
  class SummaryPreviousQueryCheque < ApplicationRecord
    belongs_to :boa_vista_acerta_essencial,
               class_name: 'BoaVista::AcertaEssencial'
  end
end
