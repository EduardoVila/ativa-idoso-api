# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_decisions
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  document_type                 :string
#  document                      :string
#  score                         :string
#  approves                      :string
#  text                          :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
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
