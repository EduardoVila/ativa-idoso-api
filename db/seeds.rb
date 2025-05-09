# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

ApplicationLoader.load_gems
ApplicationLoader.load_app

# analysis_steps is an array of hashes where each hash represents a step in the analyis process.
# Each step contains the following keys:
# - :name: A symbol representing the name of the analyis step.
# - :command_class: A string representing the class name of the command to be executed for this step.
# - :index_order: An integer representing the order in which the step should be executed.
analysis_steps = [
  {
    name: :pro_score_bounced_checks,
    command_class: 'ProScore::BouncedCheckCommand',
    index_order: 1
  },
  {
    name: :provenir_big_data_corp,
    command_class: 'Provenir::BigDataCorpCommand',
    index_order: 2
  },
  {
    name: :boa_vista_acerta_essencial,
    command_class: 'BoaVista::AcertaEssencialCommand',
    index_order: 3
  },
  {
    name: :pre_predictions,
    command_class: 'PrePredictionCommand',
    index_order: 4
  },
  {
    name: :predictions,
    command_class: 'Analysis::PredictionCommand',
    index_order: 5
  }
]

analysis_steps.each do |analysis_step|
  Analysis::Step.find_or_create_by(analysis_step)
end

banned_keywords_objects = [
  {
    criminal: [
      'ameaca', 'bando', 'carcere privado', 'corrupcao', 'crime',
      'crimes', 'criminal', 'droga', 'drogas', 'entorpecente',
      'entorpecentes', 'escravo', 'estelionato', 'execucao criminal',
      'execucao de pena', 'execucao penal', 'extorsao',
      'falsidade ideologica', 'formacao de quadrilha', 'fraude',
      'fraudes', 'furto', 'ilicita', 'ilicitas', 'ilicito', 'ilicitos',
      'latrocinio', 'lei maria da penha', 'maria da penha',
      'organizacao criminosa', 'penal', 'penha', 'quadrilha',
      'receptacao', 'reducao a condicao',
      'reducao a condicao analoga a de escravo', 'roubo','sequestro',
      'substancias toxicas', 'toxico', 'toxicos', 'trafico',
      'trafico de drogas', 'trafico de entorpecentes',
      'trafico de substancias', 'trafico de substancias entorpecentes',
      'trafico de substancias ilicitas',
      'trafico de substancias proibidas',
      'trafico de substancias psicotropicas',
      'trafico de substancias quimicas', 'trafico de substancias toxicas',
      'violencia', 'violencia de genero', 'violencia domestica'
    ]
  },
  {
    lease_agreement: [
      'aluguel', 'consignatorias', 'despejo', 'locacao',
      'locacao de imoveis', 'locacao de imovel', 'renovatorias',
      'revisionais'
    ]
  },
  {
    execution: [
      'execucao', 'execucao de alimentos', 'execucao de titulo',
      'execucao de titulo de credito', 'execucao de titulo extrajudicial',
      'execucao fiscal',
    ]
  },
  {
    warranty: [
      'alienacao', 'alienacao fiduciaria',
      'alienacao fiduciaria de imovel', 'alienacao fiduciaria de veiculo',
      'apreensao', 'busca', 'busca e apreensao', 'cobranca',
      'cobranca de divida', 'fiduciaria', 'garantias'
    ]
  },
  {
    real_estate: [
      'agua', 'eletrica', 'energia', 'fornecimento',
      'fornecimento de agua', 'fornecimento de agua e esgoto',
      'fornecimento de energia', 'fornecimento de energia eletrica'
    ]
  },
  {
    negotiable_instrument: [
      'cheque', 'cheques', 'cobranca de cheques',
      'cobranca de duplicatas', 'cobranca de titulos',
      'cobranca de titulos de credito', 'direitos e titulos de credito',
      'duplicata', 'duplicatas', 'titulo de credito', 'titulos de credito'
    ]
  }
]

# Create Lawsuit::BannedKeyword instances.
banned_keywords_objects.each do |hash|
  hash.each_pair do |litigation_category, keywords|
    keywords.each do |keyword|
      Lawsuit::BannedKeyword.create!({
        keyword: keyword, litigation_category: litigation_category
      })
    end
  end
end

# Add public keys to the database from the environment variables.
public_keys = [
  {
    key: EnvHelper.fetch('RSA_PUBLIC_KEY').gsub('\\n', "\n"), # Sanitize the public key (replace escaped newlines)
    issuer: 'alpop-analysis',
    algorithm: 'RS256',
    valid_from: Time.now,
    valid_to: Time.now + 1.year,
  },
  {
    key: EnvHelper.fetch('RSA_ALPOP_PREDICTION_PUBLIC_KEY').gsub('\\n', "\n"),
    issuer: 'alpop-prediction',
    algorithm: 'RS256',
    valid_from: Time.now,
    valid_to: Time.now + 1.year,
  }
]

public_keys.each { |public_key| PublicKey.find_or_create_by(public_key) }
