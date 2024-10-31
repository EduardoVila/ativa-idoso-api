# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_documents_name, class: 'BoaVista::DocumentsName' do
    register_size { '117' }
    register_type { '241' }
    register { 'S' }
    name { 'NOME' }
    birth_date { Time.zone.today }
    document_type { 'TIPO' }
    document_number { 'NUM' }
    document_2 { 'DOC2' }
    document_3 { 'DOC3' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
