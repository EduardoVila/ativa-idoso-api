# frozen_string_literal: true

#
#   Centraliza construção de opções de ordenação a partir de parâmetros :sort e
# :order para os controladores. Ainda, provê mecanismo de configuração para
# filtrar (whitelist) parâmetros/atributos ordenáveis de fato.
#
# Uso:
# ```
# # Controlador para Usuários
# class UsersController < ...
#   # define lista (whitelist) permitida de ordenação
#   sorting %w[id name age].freeze, default: { age: :desc }
#
#   # permite ordenação pelos parâmetros :sort e :order
#   def index
#     render json: User.order(sort_options)
#   end
# end
# ```
#
module Sortable
  extend ActiveSupport::Concern

  ORDER_OPTIONS = %w[asc desc].freeze

  class_methods do
    attr_reader :sorting_default_options, :sorting_options

    #
    # Configuração do concern.
    # Uso:
    # ```
    # class MyController < ...
    #   sorting %w[id name age].freeze, default: { age: :desc }
    #
    #   def index
    #     render json: Person.order(sort_options)
    #   end
    # end
    # ```
    #
    # @param [Array] *options Opções de atributos passíveis de ordenação
    # @param [Hash] default: Ordenação inicial. ex: `{ name: :desc }` para atributo :name e direção :desc.
    #
    def sorting(*options, default:)
      @sorting_options = Array(*options)
      @sorting_default_options = { sort: default.keys.first.to_s,
                                   order: default.values.first.to_s }
    end
  end

  included do
    # facilitando o acesso às configurações
    delegate :sorting_default_options, :sorting_options, to: :class
  end

  #
  # Constrói as opções de ordenação, a serem usadas pelo método `#order` do ActiveRecord
  # Veja mais em http://guides.rubyonrails.org/active_record_querying.html#ordering
  #
  # @return [Hash] opções de ordenação para o ActiveRecord
  #
  def sort_options
    options = params.permit(:sort, :order)

    # whitelisting
    sort = if sorting_options.include?(
      options[:sort]
    )
             options[:sort]
           else
             sorting_default_options[:sort]
           end
    order = if ORDER_OPTIONS.include?(
      options[:order]
    )
              options[:order]
            else
              sorting_default_options[:order]
            end

    # Para ser usado como:
    #   - Intrest.order(sort_options)
    #   => Interest.order(created_at: :desc)
    {
      sort => order,
      id: 'asc' # this is reuired because PostgreSQL need a uniq key to perform pagination
    }
  end
end
