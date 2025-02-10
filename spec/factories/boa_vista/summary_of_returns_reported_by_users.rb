# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_summary_of_returns_reported_by_users
#
#  id                            :bigint           not null, primary key
#  document_number               :string
#  document_type                 :string
#  first_devolution_date         :string
#  last_devolution_date          :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  total                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_summary_of_return_reported_by_user_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
