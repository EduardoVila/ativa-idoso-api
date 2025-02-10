# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_trials
#
#  id               :bigint           not null, primary key
#  kind             :string
#  subject          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  idwall_report_id :bigint           not null
#
# Indexes
#
#  index_idwall_trials_on_idwall_report_id  (idwall_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (idwall_report_id => idwall_reports.id)
#
module Idwall
  class Trial < ApplicationRecord
    belongs_to :idwall_report, class_name: 'Idwall::Report'

    has_many :trial_parts, class_name: 'Idwall::TrialPart',
                           dependent: :destroy,
                           foreign_key: 'idwall_trial_id',
                           inverse_of: :idwall_trial

    delegate :name, to: :idwall_report

    def own_part_required?
      required_name, suitor_name = nil

      trial_parts.each do |trial_part|
        name = trial_part.name
        title = trial_part.title

        required_name = trial_part_required(title, required_name, name)
        suitor_name = trial_part_suitor(title, suitor_name, name)
      end

      return true if required_name.blank? || suitor_name.blank?

      distance_lower?(required_name, suitor_name)
    end

    def defendant_and_disapproved?
      own_part_required?
    end

    private

    def trial_part_required(title, required_name, trial_part_name)
      return required_name if required_words.exclude?(title)

      if required_name.blank? || distance_lower?(trial_part_name, required_name)
        return trial_part_name
      end

      required_name
    end

    def trial_part_suitor(title, suitor_name, trial_part_name)
      return suitor_name if suitor_words.exclude?(title)

      if suitor_name.blank? || distance_lower?(trial_part_name, suitor_name)
        return trial_part_name
      end

      suitor_name
    end

    def distance_lower?(name1, name2)
      check_name_distance(name1) < check_name_distance(name2)
    end

    def check_name_distance(value)
      dl = DamerauLevenshtein
      formatted_name = formatted_string(name)

      dl.distance(formatted_name, formatted_string(value))
    end

    def required_words
      ['REQDO', 'REQDA', 'REQUERIDO', 'REQUERIDA', 'APELADO', 'IMPETRADO',
       'EXECUTADO', 'SOLICITADO', 'PRETENDIDO', 'PLEITEADO', 'EXIGIDO',
       'EXIGIDA', 'REQUISITADO', 'REQUISITADA', 'AGENCIADO', 'AGENCIADA',
       'DILIGENCIADO', 'DILIGENCIADA', 'POSTULADO', 'POSTULADA', 'PEDIDO',
       'PEDIDA', 'SUPLICADO', 'SUPLICADA', 'IMPLORADO', 'IMPLORADA',
       'POLO PASSIVO', 'REU', 'APELADOA', 'EMBARGADO', 'EMBARGADOA',
       'RECORRIDOA', 'EXECUTADO', 'VITIMA', 'AGRAVADO']
    end

    def suitor_words
      ['REQTE', 'REQUERENTE', 'IMPETRANTE', 'EXEQUENTE', 'SUPLICANTE',
       'SUPLICE', 'REPRELEG', 'POLO ATIVO', 'AUTOR', 'APELANTE',
       'EMBARGANTE', 'EXEQUENTE', 'AUTOR DO FATO', 'AGRAVANTE', 'RECORRENTE',
       'TERINTCER', 'LESADO']
    end

    def formatted_string(value = '')
      value.downcase.unaccent
    end
  end
end
