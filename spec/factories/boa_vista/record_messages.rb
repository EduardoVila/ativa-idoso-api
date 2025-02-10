# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_record_messages
#
#  id                            :bigint           not null, primary key
#  record_reference              :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  text                          :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_record_messages_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
