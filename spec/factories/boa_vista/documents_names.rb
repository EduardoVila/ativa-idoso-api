# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_documents_names
#
#  id                            :bigint           not null, primary key
#  birth_date                    :string
#  document_2                    :string
#  document_3                    :string
#  document_number               :string
#  document_type                 :string
#  name                          :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_documents_names_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
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
