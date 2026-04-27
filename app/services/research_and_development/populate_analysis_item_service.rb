# frozen_string_literal: true

module ResearchAndDevelopment
  class PopulateAnalysisItemService < ApplicationService
    include Nestable

    def initialize(analysis_item_id)
      @analysis_item = Analysis::Item.find(analysis_item_id)
    end

    def call
      klass = ResearchAndDevelopment::AnalysisItem
      hash = generate_hash(@analysis_item, {})
      formatted_data = hash.deep_stringify_keys

      klass.create(initialize_nested_attributes(formatted_data, klass.new))
    end

    private

    def generate_hash(resource, hash)
      attrs = resource.attributes.except(
        'raw_data', 'updated_at'
      )

      hash.merge!(add_prefix(resource.class.table_name, attrs))

      model_class = resource.class

      traverse_downward_associations(model_class, resource, hash)

      hash
    end

    def traverse_downward_associations(model_class, resource, hash)
      model_class.reflect_on_all_associations.each do |assoc|
        unless %i[has_one has_many].include?(assoc.macro) &&
               ignored_tables.exclude?(assoc.name)
          next
        end

        next one_child(resource, assoc, hash) if assoc.macro == :has_one

        many_child(resource, assoc, hash)
      end
    end

    def one_child(resource, assoc, hash)
      has_one_child = resource.send(assoc.name)

      return if has_one_child.nil?

      generate_hash(has_one_child, hash)
    end

    def many_child(resource, assoc, hash)
      key_name = generate_prefix(assoc.table_name)

      hash[key_name] = resource.send(assoc.name).map do |child|
        generate_hash(child, {})
      end
    end

    def ignored_tables
      %i[audits steps item_step_items updates clones]
    end

    def add_prefix(class_name, attrs)
      prefix = generate_prefix(class_name.underscore.tr('/', '_'))

      attrs.each_with_object({}) do |(key, value), hash|
        new_key = :"#{prefix}_#{key}"

        hash[new_key] = value
      end
    end

    def generate_prefix(name)
      prefixes = {
        'boa_vista_cadastral' => 'bv_cadastral',
        'boa_vista_acerta_essencial' => 'bv_acerta_essencial',
        'boa_vista' => 'bv',
        'pro_score' => 'ps',
        'serasa' => 'srs',
        'provenir' => 'prv'
      }

      prefixes.each do |key, value|
        return name.gsub(key, value) if name.include?(key)
      end

      name
    end
  end
end
