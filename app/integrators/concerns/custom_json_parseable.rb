# frozen_string_literal: true

#
# Methods to implement custom_provenir_json_parse.
# They solve the problem of nested hashes with repeated keys and without
# arrays to represent the children of a parent hash.
# These methods are responsible for parsing the JSON response from Provenir
# and returning a normalized JSON.
#
# The nested hashes of Provenir's JSON file are described in the nested_models
# method.

module CustomJsonParseable
  extend ActiveSupport::Concern

  private

  def custom_provenir_json_parse(json_str) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    custom_json = JSON.parse preprocess(json_str)

    root_key = custom_json['Alpop']['BigDataCorp']

    nested_models.each do |model|
      if model[:parent].is_a?(Array)
        # If model[:parent] is an array, it means that there are two or more
        # levels of nesting. I.e. the parent itself is a nested hash, and the
        # children are nested hashes inside the parent hash.
        #
        # The related_keys is an array whose elements are the keys to access
        # the nested hash inside the root hash.
        # The first element is the first key of the parent hash.
        # The last element is the last key of the parent hash, suffixed with
        # a number, starting from 1. This number is incremented until the
        # nested hash does not exist. It serves the purpose of identifying
        # the nested hashes with repeated keys inside the parent hash.
        #
        # If the nested hash does not exist, the loop breaks.
        # Otherwise, the children are iterated, and the nested hash is
        # updated with the children.
        # The loop continues until the nested hash does not exist.

        digit = 1

        loop do
          related_keys = model[:parent].map.with_index do |key, index|
            index == model[:parent].size - 1 ? "#{key}_#{digit}" : key
          end

          nested_hash = get_deep_nested_hash root_key, related_keys

          break if nested_hash.nil?

          model[:children].each do |child_key|
            nested_hash[child_key] = get_nested_numbered_children(
              nested_hash, child_key
            )
          end

          digit += 1
        end
      elsif model[:parent].is_a?(String)
        # If model[:parent] is a string, it means that is a one level shallow
        # nesting, and the children are nested hashes inside the parent hash.
        # The parent hash is accessed by the root hash and the parent key.
        # Then it is updated with the children.

        parent_key = model[:parent]
        parent_hash = root_key[parent_key]

        parent_data = get_parent_data_without_children(
          parent_hash, model[:children]
        )

        next if parent_data.nil?

        model[:children].each do |child_key|
          parent_data[child_key] = get_nested_numbered_children(
            parent_hash, child_key
          )
        end

        root_key[parent_key] = parent_data
      end
    end

    custom_json
  end

  def nested_models
    # This method returns a list of hashes, each hash represents a parent
    # model and its children.
    #
    # The parent model is represented by the key :parent, and the children
    # are represented by the key :children.
    #
    # The children are an array of strings, and the parent is a string or
    # an array of strings.
    #
    # If the parent is an array of strings, it means that the parent is a
    # nested hash, and the children are nested hashes inside the parent
    # hash.
    [
      {
        parent: %w[Processes Lawsuits],
        children: %w[Decisions Parties Petitions Updates]
      },
      {
        parent: 'Processes',
        children: ['Lawsuits']
      },
      {
        parent: 'BusinessRelationships',
        children: ['BusinessRelationshipsArray']
      },
      {
        parent: 'ExtendedAddresses',
        children: ['Addresses']
      },
      {
        parent: 'ExtendedPhones',
        children: ['phones']
      },
      {
        parent: 'FinantialData',
        children: ['TaxReturns']
      },
      {
        parent: 'RelatedPeople',
        children: ['PersonalRelationships']
      }
    ]
  end

  def get_parent_data_without_children(parent_hash, _children)
    # This method returns a hash with the parent data without the children
    parent_hash&.select do |key, value|
      !value.is_a?(Hash) || !key.starts_with?("#{key}_")
    end
  end

  def get_nested_numbered_children(parent_hash, child_key)
    # This method returns an array with the children of a parent hash
    parent_hash&.select { |key, value| key.starts_with? "#{child_key}_" }
      &.values
  end

  def get_deep_nested_hash(root_key, related_keys)
    # This method returns a nested hash inside of a parent nested hash.
    # The purpose of this method is to access the nested hash inside the
    # parent nested hash, using the related_keys to access the nested hash.
    # If the nested hash does not exist, it returns nil.
    # Otherwise, it returns the nested hash.

    current_value = root_key

    related_keys.each do |key|
      return nil unless current_value.is_a?(Hash) && current_value.key?(key)

      current_value = current_value[key]
    end

    current_value
  end

  def preprocess(json_str)
    # Identifies the repeated keys in the nested models.
    repeated_keys = nested_models.map { |model| model[:children] }.flatten

    repeated_keys.each do |key|
      count = 0
      pattern = /"#{key}"/

      # Substitutes each occurrence of the key with a unique numbered key
      json_str = json_str.gsub(pattern) do |match|
        count += 1
        "\"#{key}_#{count}\""
      end
    end

    json_str
  end
end
