# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cadastrals
#
#  id            :bigint           not null, primary key
#  raw_data      :string
#  consumer_type :string           not null
#  consumer_id   :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :boa_vista_cadastral, class: 'BoaVista::Cadastral' do
    raw_data { '{}' }

    consumer factory: %i[analysis_item]
  end
end
