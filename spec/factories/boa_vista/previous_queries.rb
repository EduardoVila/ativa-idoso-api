# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_previous_queries
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  occurrence_type               :string
#  date                          :string
#  currency                      :string
#  value                         :string
#  informant                     :string
#  product                       :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
FactoryBot.define do
  factory :boa_vista_previous_query, class: 'BoaVista::PreviousQuery' do
    register_size { '66' }
    register_type { '126' }
    register { 'S' }
    occurrence_type { 'TIPO OCORRENCIA' }
    date { Time.zone.today }
    currency { 'R$' }
    value { 'VALOR' }
    informant { 'INFORMANTE' }
    product { 'PRODUTO' }

    boa_vista_acerta_essencial
  end
end
