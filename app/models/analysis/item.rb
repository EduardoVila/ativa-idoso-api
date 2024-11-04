# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_items
#
#  id                    :uuid             not null, primary key
#  name                  :string
#  cpf                   :string
#  status                :integer          default("todo")
#  error_status          :integer          default("none")
#  prediction            :integer
#  payment_situation     :integer          default("unanalyzed")
#  disapproval_situation :integer
#  clone_of_id           :uuid
#  analysis_report_id    :uuid             not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
require 'require_all'

require_all 'app/models/concerns/delegators'

module Analysis
  class Item < ApplicationRecord
    include Delegators::Serasa
    include Delegators::ProScore
    include Delegators::BoaVistaAcertaEssencial
    include Delegators::BoaVistaCadastral
    include Delegators::Provenir

    before_validation :cpf_normalizer

    enum status: { todo: 0, wip: 1, done: 2, not_found: 3, error: 4 }
    enum error_status: {
      none: 0,
      idwall: 1,
      boa_vista: 2,
      pro_score_trials: 3,
      serasa: 4,
      pro_score_family_holdings: 5,
      pro_score_bounced_checks: 6,
      pro_score_presumed_income: 7,
      pro_score_commercial_relations: 8,
      provenir_big_data_corp: 9
    }, _suffix: true

    enum disapproval_situation: {
      debtor: 1, # when has debits with Alpop
      blocked_negativity: 2, # when has blocked negativity
      reproved_by_trial: 3,
      insufficient_income: 4,
      exceeded_debits: 5,
      blocked_cpf: 6,
      reproved_by_relative: 7,
      reproved_by_bounced_check: 8,
      reproved_by_age_and_income: 9,
      reproved_by_obit_indication: 10,
      reproved_by_protested_title: 11,
      reproved_by_recent_debit: 12
    }

    enum payment_situation: {
      unanalyzed: 0, good_payer: 1, no_payer: 2, new_client: 3, late_payer: 4
    }, _suffix: true

    validates :status, inclusion: { in: statuses.keys }
    validates :error_status, inclusion: { in: error_statuses.keys }
    validates :disapproval_situation,
              inclusion: { in: disapproval_situations.keys },
              allow_nil: true
    validates :payment_situation, inclusion: { in: payment_situations.keys }
    validate :validate_monthly_score_limit

    with_options presence: true do
      validates :cpf # , cpf: true TODO add this validation
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

    def cpf_normalizer
      self.cpf = CPF::Formatter.format cpf if cpf.present?
    end

    private

    def validate_monthly_score_limit
      scores_this_month = Analysis::Item.where(
        created_at: Time.current.all_month
      ).count

      errors.add(:base, :monthly_score_limit) if scores_this_month > 4000
    end
  end
end
