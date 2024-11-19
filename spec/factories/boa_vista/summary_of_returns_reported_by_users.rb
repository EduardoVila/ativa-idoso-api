# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_summary_of_returns_reported_by_users
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  document_type                 :string
#  document_number               :string
#  total                         :string
#  first_devolution_date         :string
#  last_devolution_date          :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
FactoryBot.define do
  factory :boa_vista_summary_of_returns_reported_by_user,
          class: 'BoaVista::SummaryOfReturnsReportedByUser' do
    register_size { '157' }
    register_type { '244' }
    register { 'S' }
    document_type { 'TIPO DOC' }
    document_number { 'NUM DOC' }
    total { 'TOTAL' }
    first_devolution_date { Time.zone.today }
    last_devolution_date { Time.zone.today }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
