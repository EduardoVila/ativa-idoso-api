# frozen_string_literal: true

#
# EmptyResponseError - erro específico para o caso de um integrador retornar
# status 200, porém com body vazio (ex. já aconteceu com frequência na ProScore.
#
class EmptyResponseError < StandardError; end
