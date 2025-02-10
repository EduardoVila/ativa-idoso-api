# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cadastrals
#
#  id            :bigint           not null, primary key
#  consumer_type :string           not null
#  raw_data      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  consumer_id   :uuid             not null
#
# Indexes
#
#  index_boa_vista_cadastrals_on_consumer  (consumer_type,consumer_id) UNIQUE
#
FactoryBot.define do
  factory :boa_vista_cadastral, class: 'BoaVista::Cadastral' do
    raw_data { '{}' }

    consumer factory: %i[analysis_item]
  end
end
