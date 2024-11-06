# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_negative_items
#
#  id              :bigint           not null, primary key
#  occurrence_date :date
#  legal_nature_id :string
#  legal_nature    :string
#  contract_id     :string
#  creditor_name   :string
#  amount          :float
#  city            :string
#  federal_unit    :string
#  principal       :boolean
#  owner_type      :string
#  owner_id        :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
module Serasa
  class NegativeItem < ApplicationRecord
    belongs_to :owner, polymorphic: true

    scope :current_semester, lambda {
      start_date = Time.zone.today - 6.months
      end_date = Time.zone.today

      where(occurrence_date: start_date.to_date..end_date.to_date)
    }

    def disapproved?
      check_disapproved_words?(creditor_name) ||
        check_disapproved_words?(legal_nature)
    end

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
        'nu financeira', 'nu', 'nu bank', 'mercado', 'mercadopago', 'pago',
        'avalyst', 'credpago', 'porto seguro'
      ]
    end
  end
end
