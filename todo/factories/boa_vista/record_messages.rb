# frozen_string_literal: true

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
