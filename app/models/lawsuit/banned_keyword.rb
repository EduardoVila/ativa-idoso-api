# frozen_string_literal: true

# == Schema Information
#
# Table name: lawsuit_banned_keywords
#
#  id                  :bigint           not null, primary key
#  keyword             :string
#  litigation_category :integer          default("criminal")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

module Lawsuit
  class BannedKeyword < ApplicationRecord
    with_options presence: true do
      validates :keyword
      validates :litigation_category
    end

    enum :litigation_category, [
      :criminal, # Criminal ou penal.
      :lease_agreement, # Locação: ações de despejo revisionais renovatórias consignatórias etc.
      :execution, # Execução: títulos de execução extrajudicial e judicial.
      :warranty, # Garantias: ações de cobrança alienação fiduciária busca e apreensão etc.
      :real_estate, # Imobiliário: ações de usucapião reintegração de posse fornecimento de água etc.
      :negotiable_instrument # Títulos de crédito: ações de cobrança de cheques duplicatas etc.
    ]

    validates :litigation_category,
              inclusion: { in: litigation_categories.keys }

    scope :non_exceptionable_litigation_categories, lambda {
      where(litigation_category: %i[criminal lease_agreement])
    }
    scope :non_exceptionable_keywords, lambda {
      non_exceptionable_litigation_categories.pluck(:keyword)
    }
    scope :exceptionable_litigation_categories, lambda {
      where.not(litigation_category: %i[criminal lease_agreement])
    }
    scope :exceptionable_keywords, lambda {
      exceptionable_litigation_categories.pluck(:keyword)
    }
    scope :all_banned_keywords, -> { all.pluck(:keyword) }
    scope :by_litigation_category, lambda { |litigation_category|
      where(litigation_category:).pluck(:keyword)
    }
  end
end
