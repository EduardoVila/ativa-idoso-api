# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_items
#
#  id                 :bigint           not null, primary key
#  numero_plugin      :string
#  numero_processo    :string
#  instancia          :string
#  data_inicio        :datetime
#  assuntos           :string
#  classes            :string
#  pro_score_trial_id :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :pro_score_trial_item, class: 'ProScore::TrialItem' do
    numero_plugin { '5194' }
    numero_processo { SecureRandom.hex }
    instancia { 'TRIBUNAL DE JUSTICA DE SAO PAULO ESAJ 1 GRAU' }
    data_inicio { Time.zone.today }
    assuntos { 'LOCACAO DE IMOVEL' }
    classes { 'DESPEJO POR FALTA DE PAGAMENTO CUMULADO COM COBRANCA' }

    trial { create :pro_score_trial }
  end
end
