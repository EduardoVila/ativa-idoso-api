# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_stolen_documents
#
#  id                :bigint           not null, primary key
#  detailed_reason   :string
#  document_number   :string
#  document_type     :string
#  inclusion_date    :datetime
#  issuing_authority :string
#  occurrence_date   :date
#  occurrence_state  :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  serasa_fact_id    :bigint           not null
#
# Indexes
#
#  index_serasa_stolen_documents_on_serasa_fact_id  (serasa_fact_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_fact_id => serasa_facts.id)
#
FactoryBot.define do
  factory :serasa_stolen_document, class: 'Serasa::StolenDocument' do
    fact factory: :serasa_fact
  end
end
