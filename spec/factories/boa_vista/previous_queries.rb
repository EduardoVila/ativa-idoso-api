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
