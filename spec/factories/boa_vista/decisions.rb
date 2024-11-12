# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_decision, class: 'BoaVista::Decision' do
    register_size { '224' }
    register_type { '603' }
    register { 'S' }
    document_type { 'TIPO DOC' }
    document { 'DOC' }
    score { 'SCORE' }
    approves { 'APROVA' }
    text { 'TEXTO' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
