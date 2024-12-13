# frozen_string_literal: true

module AssociationAliasable
  extend ActiveSupport::Concern

  class_methods do
    def association_aliases
      const_get(:ASSOCIATION_ALIASES)
    rescue NameError
      {}
    end

    def association_alias(association)
      association_aliases[association&.to_sym]
    end
  end
end
