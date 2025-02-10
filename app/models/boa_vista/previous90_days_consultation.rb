# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_previous90_days_consultations
#
#  id                            :bigint           not null, primary key
#  month_1                       :string
#  month_2                       :string
#  month_3                       :string
#  month_4                       :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  total                         :string
#  total_1                       :string
#  total_2                       :string
#  total_3                       :string
#  total_4                       :string
#  year_1                        :string
#  year_2                        :string
#  year_3                        :string
#  year_4                        :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_previous90_days_consultations_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
module BoaVista
  class Previous90DaysConsultation < ApplicationRecord
    belongs_to :boa_vista_acerta_essencial,
               class_name: 'BoaVista::AcertaEssencial'
  end
end
