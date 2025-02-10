# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_debit_occurrences
#
#  id                            :bigint           not null, primary key
#  accumulated_value             :string
#  biggest_debit_date            :string
#  biggest_debit_value           :string
#  first_debit_date              :string
#  first_debit_value             :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  total_debtor                  :string
#  total_guarantor               :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_debit_occurrences_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
FactoryBot.define do
  factory :boa_vista_debit_occurrence, class: 'BoaVista::DebitOccurrence' do
    register_size { '065' }
    register_type { '108' }
    register { 'S' }
    total_debtor { '1000' }
    total_guarantor { '500' }
    accumulated_value { '10000' }
    first_debit_date { Time.zone.today }
    first_debit_value { '2000' }
    biggest_debit_date { Time.zone.today }
    biggest_debit_value { '10000' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
