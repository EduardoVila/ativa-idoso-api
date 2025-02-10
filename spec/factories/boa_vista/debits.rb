# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_debits
#
#  id                            :bigint           not null, primary key
#  availability_date             :string
#  condition                     :string
#  contract                      :string
#  currency                      :string           default("0")
#  informant                     :string
#  informed_by_querent           :string
#  occurrence_date               :string
#  occurrence_type               :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  segment                       :string
#  value                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_debits_on_boa_vista_acerta_essencial_id  (boa_vista_acerta_essencial_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
DISAPPROVED_WORDS = [
  'sinistro', 'imob', 'energia', 'eletrica', 'eletro',
  'companhia de energia', 'lojas cem', 'loja', 'havan', 'luizacred',
  'luiza', 'bahia', 'optica', 'otica', 'marisa', 'riachuelo', 'lingerie',
  'comercio', 'alianca', 'celpa', 'celpe', 'cemar', 'chesp', 'cocel',
  'coelba', 'cosern', 'cpfl', 'edp', 'elektro', 'eletropaulo', 'enel',
  'energisa', 'forcel', 'iguacu', 'jari', 'cesa', 'light', 'muxfeldt',
  'palma', 'panambi', 'rge', 'santa maria', 'luz', 'forca', 'sulgipe',
  'ceee-d', 'celesc', 'cemig', 'cerr', 'copel', 'eletrobras', 'sicredi',
  'cesta basica', 'cesta', 'telefonica', 'senffnet', 'voxcred',
  'nu financeira', 'nu', 'nu bank', 'mercado', 'mercadopago', 'pago'
].freeze

FactoryBot.define do
  factory :boa_vista_debit, class: 'BoaVista::Debit' do
    register_size { '138' }
    register_type { '124' }
    register { 'S' }
    occurrence_type { 'TIPO' }
    segment { 'SEGMENTO' }
    occurrence_date { Time.zone.today.strftime('%d/%m/%Y') }
    contract { 'CONTRATO' }
    availability_date { Time.zone.today.strftime('%d/%m/%Y') }
    currency { 'R$' }
    value { '100' }
    condition { 'SITUACAO' }
    informant { 'INFORMANTE' }
    informed_by_querent { 'INFORMADO' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo

    trait :disapproved_segment do
      segment { DISAPPROVED_WORDS.sample }
    end

    trait :disapproved_informant do
      informant { DISAPPROVED_WORDS.sample }
    end
  end
end
