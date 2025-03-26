# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_acerta_essencials
#
#  id            :bigint           not null, primary key
#  consumer_type :string           not null
#  cpf           :string           not null
#  credit_type   :integer          default("CC"), not null
#  raw_data      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  consumer_id   :bigint           not null
#
# Indexes
#
#  index_boa_vista_acerta_essencials_on_consumer  (consumer_type,consumer_id) UNIQUE
#
FactoryBot.define do
  factory :boa_vista_acerta_essencial, class: 'BoaVista::AcertaEssencial' do
    cpf { Faker::CPF.pretty }
    credit_type { :CC }
    raw_data { '{}' }

    consumer factory: :analysis_item
  end
end
