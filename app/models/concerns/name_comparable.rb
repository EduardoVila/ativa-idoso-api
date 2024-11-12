# frozen_string_literal: true

require 'damerau-levenshtein'

module NameComparable
  extend ActiveSupport::Concern

  private

  def name1_closer_to_compared_name?(compared_name, name1, name2)
    check_name_distance(compared_name, name1) <=
      check_name_distance(compared_name, name2)
  end

  def check_name_distance(compared_name, name_to_be_compared)
    dl = DamerauLevenshtein
    formatted_name = formatted_string(compared_name)

    dl.distance(formatted_name, formatted_string(name_to_be_compared || ''))
  end
end
