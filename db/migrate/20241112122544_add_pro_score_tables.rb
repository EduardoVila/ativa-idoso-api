class AddProScoreTables < ActiveRecord::Migration[8.0]
  def change
    create_table :pro_score_reports do |t|
      t.string :raw_data
      t.text :performed_searches, default: [], array: true
      t.references :analysis_item, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :pro_score_family_assistances do |t|
      t.string :numero_plugin
      t.string :valor
      t.string :ultima_data_do_beneficio
      t.string :consta_beneficio
      t.references :pro_score_report, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :pro_score_emergency_assistances do |t|
      t.string :numero_plugin
      t.string :mes_disponibilizado
      t.string :codigo_do_municipio
      t.string :municipio
      t.string :uf
      t.string :parcelas
      t.string :valor
      t.string :enquadramento
      t.string :observacao
      t.references :pro_score_report, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :pro_score_monthly_benefits do |t|
      t.string :numero_plugin
      t.string :mes_competencia
      t.string :mes_referencia
      t.string :uf
      t.string :nome_municipio
      t.string :nis_beneficiario
      t.string :numero_beneficio
      t.string :beneficio_concedido_judicialmente
      t.string :valor_parcela
      t.references :pro_score_report, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :pro_score_family_holdings do |t|
      t.string :numero_plugin
      t.string :cpf_do_parente
      t.string :nome_do_parente
      t.string :grau_de_parentesco
      t.references :pro_score_report, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :pro_score_bounced_checks do |t|
      t.string :numero_plugin
      t.string :codigo_do_banco
      t.string :nome_do_banco
      t.string :numero_da_agencia
      t.string :quantidade_de_ocorrencias
      t.string :motivo_da_ocorrencia
      t.string :data_da_ultima_ocorrencia
      t.references :pro_score_report, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :pro_score_commercial_relations do |t|
      t.string :numero_plugin
      t.string :cpfcnpj
      t.string :razao_social
      t.references :pro_score_report, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :pro_score_criminal_antecedents do |t|
      t.string :numero_plugin
      t.string :numero_da_certidao
      t.string :certidao
      t.string :data_da_emissao
      t.string :hora_da_emissao
      t.references :pro_score_report, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :pro_score_proprable_professions do |t|
      t.string :numero_plugin
      t.string :codigo
      t.string :titulo
      t.references :pro_score_report, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :pro_score_presumed_salary_ranges do |t|
      t.string :numero_plugin
      t.string :codigo_da_faixa_salarial
      t.string :faixa_salarial
      t.string :descricao_da_faixa
      t.references :pro_score_report, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :pro_score_presumed_incomes do |t|
      t.string :numero_plugin
      t.string :valor_da_renda_presumida
      t.references :pro_score_report, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :pro_score_trials do |t|
      t.string :numero_plugin
      t.string :numero_do_processo_unico
      t.datetime :data_distribuicao
      t.string :area
      t.string :causa_moeda
      t.string :causa_valor
      t.string :unidade_origem
      t.string :url_processo
      t.string :sistema
      t.datetime :data_processamento
      t.string :tribunal
      t.string :uf
      t.string :segmento
      t.string :classe_processual_nome
      t.string :orgao_julgador
      t.string :juiz
      t.references :pro_score_report, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :pro_score_trial_parts do |t|
      t.string :numero_plugin
      t.string :numero_do_processo_unico
      t.string :nome
      t.string :documento
      t.string :tipo
      t.string :polo
      t.references :pro_score_trial, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :pro_score_trial_topics do |t|
      t.string :numero_plugin
      t.string :numero_do_processo_unico
      t.string :codigo_cnpj
      t.string :titulo
      t.references :pro_score_trial, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :pro_score_trial_motions do |t|
      t.string :numero_plugin
      t.string :numero_do_processo_unico
      t.datetime :data
      t.string :nome_original
      t.references :pro_score_trial, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :pro_score_trial_lawyers do |t|
      t.string :numero_plugin
      t.string :numero_do_processo_unico
      t.string :advogado_nome
      t.string :parte_nome
      t.string :cpf
      t.string :cnpj
      t.string :tipo
      t.string :oab_numero
      t.string :oab_uf
      t.references :pro_score_trial, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :pro_score_authentications do |t|
      t.string :token_type
      t.string :refresh_token
      t.string :access_token
      t.integer :expires_in
      t.timestamps
    end
  end
end
