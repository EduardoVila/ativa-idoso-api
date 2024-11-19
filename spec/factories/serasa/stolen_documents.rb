# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_stolen_documents
#
#  id                :uuid             not null, primary key
#  occurrence_date   :date
#  inclusion_date    :datetime
#  document_type     :string
#  document_number   :string
#  issuing_authority :string
#  detailed_reason   :string
#  occurrence_state  :string
#  serasa_fact_id    :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :serasa_stolen_document, class: 'Serasa::StolenDocument' do
    fact factory: :serasa_fact
  end
end
