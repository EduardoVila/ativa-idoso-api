# frozen_string_literal: true

# This rake stands for creating entries of keywords related to lawsuits objects.
# <rails create_lawsuit_banned_keywords:run> at the terminal will trigger this rake.
# This rake is useful in the LawsuitsAnalyzable concern.

def create_banned_keywords(litigation_category, keywords)
  keywords.each do |keyword|
    Lawsuit::BannedKeyword.create!(
      {
        keyword: keyword, litigation_category: litigation_category
      }
    )
  end
end

namespace :create_lawsuit_banned_keywords do
  desc 'Create Lawsuit::BannedKeyword instances. Useful in LawsuitsAnalyzable.'

  task run: :environment do
    # Define banned keywords related to lawsuits.
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
          'reducao a condicao analoga a de escravo', 'roubo', 'sequestro',
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
          'execucao fiscal'
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

    # Destroy all Lawsuit::BannedKeyword instances.
    Lawsuit::BannedKeyword.in_batches.destroy_all

    # Create Lawsuit::BannedKeyword instances.
    banned_keywords_objects.each do |hash|
      hash.each_pair do |litigation_category, keywords|
        create_banned_keywords(litigation_category, keywords)
      end
    end
  end
end
