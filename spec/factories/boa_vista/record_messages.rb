# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_record_messages
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  record_reference              :string
#  text                          :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
FactoryBot.define do
  factory :boa_vista_record_message, class: 'BoaVista::RecordMessage' do
    register_size { '207' }
    register_type { '940' }
    register { 'S' }
    record_reference { 'REGISTRO DE REFERENCIA' }
    text { 'TEXTO' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
