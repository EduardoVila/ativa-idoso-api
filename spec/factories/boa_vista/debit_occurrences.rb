# frozen_string_literal: true

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
