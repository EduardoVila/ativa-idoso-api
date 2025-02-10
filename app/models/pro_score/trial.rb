# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trials
#
#  id                       :bigint           not null, primary key
#  area                     :string
#  causa_moeda              :string
#  causa_valor              :string
#  classe_processual_nome   :string
#  data_distribuicao        :datetime
#  data_processamento       :datetime
#  juiz                     :string
#  numero_do_processo_unico :string
#  numero_plugin            :string
#  orgao_julgador           :string
#  segmento                 :string
#  sistema                  :string
#  tribunal                 :string
#  uf                       :string
#  unidade_origem           :string
#  url_processo             :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pro_score_report_id      :bigint           not null
#
# Indexes
#
#  index_pro_score_trials_on_pro_score_report_id  (pro_score_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
#

#
# Plaintiff stands for "autor da ação/processo judicial",
# or simply "polo ativo" in a broader sense.
#
# Defendant stands for "réu de ação/processo judicial",
# or simply "polo passivo" in a broader sense.
#
module ProScore
  class Trial < ApplicationRecord
    include NameComparable

    belongs_to :report, class_name: 'ProScore::Report',
                        foreign_key: 'pro_score_report_id',
                        inverse_of: :trials

    has_many :parts, class_name: 'ProScore::TrialPart',
                     dependent: :destroy,
                     foreign_key: 'pro_score_trial_id',
                     inverse_of: :trial

    has_many :lawyers, class_name: 'ProScore::TrialLawyer',
                       dependent: :destroy,
                       foreign_key: 'pro_score_trial_id',
                       inverse_of: :trial

    has_many :topics, class_name: 'ProScore::TrialTopic',
                      dependent: :destroy,
                      foreign_key: 'pro_score_trial_id',
                      inverse_of: :trial

    has_many :motions, class_name: 'ProScore::TrialMotion',
                       dependent: :destroy,
                       foreign_key: 'pro_score_trial_id',
                       inverse_of: :trial

    validates :numero_do_processo_unico, uniqueness: { scope: :report }

    def defendant
      defendant?
    end

    def defendant_and_disapproved
      defendant_and_disapproved?
    end

    def name
      report.analysis_item.name
    end

    def titles
      topics.pluck(:titulo)
    end

    def defendant_and_disapproved?
      defendant? && (
        check_disapproved_words?(classe_processual_nome) ||
        check_disapproved_words?(area) ||
        check_disapproved_words?(titles.join(' '))
      )
    end

    def compared_name
      @compared_name ||= name
    end

    def defendant?
      defendant_name, plaintiff_name = nil

      parts.each do |trial_part|
        party_name = trial_part.nome
        title = trial_part.tipo

        defendant_name = trial_part_defendant(title, defendant_name, party_name)
        plaintiff_name = trial_part_plaintiff(title, plaintiff_name, party_name)
      end

      return true if defendant_name.blank? || plaintiff_name.blank?

      name1_closer_to_compared_name?(
        compared_name, defendant_name, plaintiff_name
      )
    end

    private

    def trial_part_defendant(title, defendant_name, trial_part_name)
      return defendant_name if defendant_words.exclude?(title)

      if defendant_name.blank? ||
         name1_closer_to_compared_name?(
           compared_name, trial_part_name, defendant_name
         )

        return trial_part_name
      end

      defendant_name
    end

    def trial_part_plaintiff(title, plaintiff_name, trial_part_name)
      return plaintiff_name if plaintiff_words.exclude?(title)

      if plaintiff_name.blank? ||
         name1_closer_to_compared_name?(
           compared_name, trial_part_name, plaintiff_name
         )

        return trial_part_name
      end

      plaintiff_name
    end

    def defendant_words
      [
        'AGENCIADA', 'AGENCIADO', 'AGRAVADA', 'AGRAVADO', 'APELADA', 'APELADO',
        'APELADOA', 'CIRCUNSTANCIADA', 'CIRCUNSTANCIADO', 'DEMANDADA',
        'DEMANDADO', 'DENUNCIADA', 'DENUNCIADO', 'DEVEDOR', 'DEVEDORA',
        'DILIGENCIADA', 'DILIGENCIADO', 'EMBARGADA', 'EMBARGADO', 'EXECUTADA',
        'EXECUTADO', 'EXIGIDA', 'EXIGIDO', 'IMPETRADA', 'IMPETRADO',
        'IMPLORADA', 'IMPLORADO', 'INVESTIGADA', 'INVESTIGADO', 'PACIENTE',
        'PEDIDA', 'PEDIDO', 'PLEITEADA', 'PLEITEADO', 'POLO PASSIVO',
        'POSTULADA', 'POSTULADO', 'PRETENDIDA', 'PRETENDIDO', 'RE', 'RECORRIDA',
        'RECORRIDO', 'RECORRIDOA', 'REQDA', 'REQDO', 'REQUERIDA', 'REQUERIDO',
        'REQUISITADA', 'REQUISITADO', 'REU', 'SOLICITADA', 'SOLICITADO',
        'SUPLICADA', 'SUPLICADO', 'CIDADAO', 'ACUSADA', 'ACUSADO', 'APENADA',
        'APENADO', 'CULPADA', 'CULPADO', 'INDICIADA', 'INDICIADO', 'PROCESSADA',
        'PROCESSADO', 'REEDUCANDA', 'REEDUCANDO', 'SENTENCIADA', 'SENTENCIADO'
      ]
    end

    def plaintiff_words
      [
        'AGRAVANTE', 'APELANTE', 'ATIVA', 'ATIVO', 'AUTOR', 'AUTORA',
        'CIRCUNSTANCIANT', 'CIRCUNSTANCIANTE', 'EMBARGANTE', 'EXEQUENTE',
        'IMPETRANTE', 'LESADA', 'LESADO', 'POLO ATIVO', 'RECORRENTE',
        'REPRELEG', 'REQTE', 'REQUERENTE', 'SUPLICANTE', 'SUPLICE', 'TERINTCER',
        'VITIMA'
      ]
    end

    def check_disapproved_words?(value)
      return false if value.blank?

      disapproved_words.any? do |word|
        formatted_string(value).include? word
      end
    end

    def disapproved_words
      [
        'alienacao fiduciaria', 'cobranca', 'condominio', 'contravencao',
        'crime', 'criminal', 'dano material', 'danos materiais', 'despejo',
        'direitos e titulos de credito', 'drogas', 'execucao de titulo',
        'fornecimento de agua', 'ilicita', 'ilicitas', 'ilicito', 'ilicitos',
        'locacao', 'penal', 'trafico'
      ]
    end
  end
end
