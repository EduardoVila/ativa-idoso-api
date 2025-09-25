# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_items
#
#  id                    :bigint           not null, primary key
#  cpf                   :string
#  disapproval_situation :integer
#  error_status          :integer          default("none")
#  features              :jsonb
#  name                  :string
#  status                :integer          default("todo")
#  steps_data            :jsonb            not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  analysis_report_id    :bigint           not null
#  clone_of_id           :bigint
#
# Indexes
#
#  index_analysis_items_on_analysis_report_id  (analysis_report_id)
#  index_analysis_items_on_clone_of_id         (clone_of_id)
#
# Foreign Keys
#
#  fk_rails_...  (analysis_report_id => analysis_reports.id)
#  fk_rails_...  (clone_of_id => analysis_items.id)
#
require 'require_all'

require_all 'app/models/concerns/delegators'
require_all 'app/models/concerns/validators'
require_all 'app/models/concerns/analysis'

module Analysis
  class Item < ApplicationRecord
    include Delegators::Serasa
    include Delegators::ProScore
    include Delegators::BoaVistaAcertaEssencial
    include Delegators::BoaVistaCadastral
    include Delegators::Provenir
    include ::Auditable
    include DisapprovalSituationConcern
    include Featurable
    include StepTrackable

    auditable

    before_validation :cpf_normalizer

    enum :status, %i[todo wip done not_found error]
    enum :error_status, %i[
      none
      idwall
      boa_vista
      pro_score_trials
      serasa
      pro_score_family_holdings
      pro_score_bounced_checks
      pro_score_presumed_income
      pro_score_commercial_relations
      provenir_big_data_corp
      alpop_prediction
    ], suffix: true

    validates :status, inclusion: { in: statuses.keys }
    validates :error_status, inclusion: { in: error_statuses.keys }
    validates :disapproval_situation,
              inclusion: { in: disapproval_situations.keys },
              allow_nil: true
    validate :validate_monthly_score_limit

    with_options presence: true do
      validates :cpf, cpf: true
      validates :status
      validates :error_status
    end

    belongs_to :report, class_name: 'Analysis::Report',
                        foreign_key: 'analysis_report_id'

    belongs_to :clone_of, class_name: 'Analysis::Item',
                          foreign_key: 'clone_of_id',
                          optional: true

    has_one :boa_vista_cadastral, class_name: 'BoaVista::Cadastral',
                                  dependent: :destroy,
                                  as: :consumer

    has_one :boa_vista_acerta_essencial,
            class_name: 'BoaVista::AcertaEssencial',
            inverse_of: :consumer,
            dependent: :destroy,
            as: :consumer

    has_one :pro_score_report, class_name: 'ProScore::Report',
                               inverse_of: :analysis_item,
                               dependent: :destroy

    has_one :provenir_big_data_corp, class_name: 'Provenir::BigDataCorp',
                                     inverse_of: :analysis_item,
                                     dependent: :destroy

    has_one :serasa_fintech_report, class_name: 'Serasa::FintechReport',
                                    inverse_of: :owner,
                                    dependent: :destroy

    has_one :idwall_report, class_name: 'Idwall::Report',
                            inverse_of: :analysis_item,
                            dependent: :destroy

    has_many :clones, class_name: 'Analysis::Item',
                      inverse_of: :clone_of,
                      dependent: :nullify

    has_many :item_steps, class_name: 'Analysis::ItemStep',
                          inverse_of: :item,
                          dependent: :destroy

    has_many :steps, through: :item_steps,
                     class_name: 'Analysis::Step',
                     inverse_of: :items,
                     dependent: :destroy

    has_many :predictions, class_name: 'Analysis::Prediction',
                           inverse_of: :item,
                           dependent: :destroy

    delegate :prediction_model_name, to: :report, allow_nil: true

    def cpf_normalizer
      self.cpf = CPF::Formatter.format cpf if cpf.present?
    end

    private

    def validate_monthly_score_limit
      scores_this_month = Analysis::Item.where(
        created_at: Time.current.all_month
      ).count

      errors.add(:base, :monthly_score_limit) if scores_this_month > ENV.fetch(
        'SCORE_MONTHLY_LIMIT', 4000
      ).to_i
    end
  end
end
