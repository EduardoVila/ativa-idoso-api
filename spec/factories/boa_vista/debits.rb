# frozen_string_literal: true

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
