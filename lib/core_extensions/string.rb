# frozen_string_literal: true

#
# Extensões para a classe String
#
module CoreExtensions
  module String
    #
    # Representação "canônica" da String, para comparações - minúsculas e sem acento
    #
    def canonic
      strip.squeeze(' ').unaccent.downcase
    end

    #
    # Remove "acentos" da String
    # Útil para comparações no banco de dados PostgreSQL, com a extenção `unaccent`
    #

    # rubocop:disable Layout/LineLength
    def unaccent
      tr 'ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž',
         'AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz'
    end
    # rubocop:enable Layout/LineLength

    def to_boolean
      ActiveRecord::Type::Boolean.new.cast self
    end
  end
end

String.include CoreExtensions::String