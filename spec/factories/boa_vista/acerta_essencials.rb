# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_acerta_essencials
#
#  id            :uuid             not null, primary key
#  cpf           :string           not null
#  credit_type   :integer          default("CC"), not null
#  raw_data      :string
#  consumer_type :string
#  consumer_id   :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :boa_vista_acerta_essencial, class: 'BoaVista::AcertaEssencial' do
    cpf { Faker::CPF.pretty }
    credit_type { :CC }
    raw_data { '{}' }

    consumer factory: :analysis_item
  end
end
