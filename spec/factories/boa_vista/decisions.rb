# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_decisions
#
#  id                            :bigint           not null, primary key
#  approves                      :string
#  document                      :string
#  document_type                 :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  score                         :string
#  text                          :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_decisions_on_boa_vista_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
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
