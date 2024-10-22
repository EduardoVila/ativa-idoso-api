# frozen_string_literal: true

require_all 'app/models/concerns/delegators'

module Analysis
  class Item < ApplicationRecord
    include Delegators::Serasa
    include Delegators::ProScore
    include Delegators::BoaVistaAcertaEssencial
    include Delegators::BoaVistaCadastral
    include Delegators::Provenir

    belongs_to :report, class_name: 'Analysis::Report'

    belongs_to :clone_of,
               class_name: 'Analysis::Item',
               optional: true,
               inverse_of: :clones

  end
end
