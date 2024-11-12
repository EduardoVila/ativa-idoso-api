# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_summary_previous_query_cheques
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  document_type                 :string
#  document_number               :string
#  total                         :string
#  value                         :string
#  day                           :string
#  day_value                     :string
#  pre_dated                     :string
#  pre_dated_value               :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
module BoaVista
  class SummaryPreviousQueryCheque < ApplicationRecord
    belongs_to :boa_vista_acerta_essencial,
               class_name: 'BoaVista::AcertaEssencial'
  end
end
