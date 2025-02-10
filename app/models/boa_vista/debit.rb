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
module BoaVista
  class Debit < ApplicationRecord
    belongs_to :boa_vista_acerta_essencial,
               class_name: 'BoaVista::AcertaEssencial',
               inverse_of: :debits

    def disapproved?
      check_disapproved_words?(informant) || check_disapproved_words?(segment)
    end

    scope :current_semester, lambda {
      start_date = Time.zone.today - 6.months
      end_date = Time.zone.today

      where(
        "to_date(occurrence_date, 'DD MM YY') BETWEEN ? and ?",
        start_date.to_date,
        end_date.to_date
      )
    }

    private

    def formatted_string(value = '')
      value.downcase.unaccent
    end

    def check_disapproved_words?(value)
      return false if value.blank?

      disapproved_words.any? do |word|
        formatted_string(value).include? word
      end
    end

    def disapproved_words
      [
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
      ]
    end
  end
end
