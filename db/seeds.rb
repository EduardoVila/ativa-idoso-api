# frozen_string_literal: true

require_relative '../config/application'

def seed_development_videos
  videos = [
    ['Membros inferiores - Idoso frágil - Vídeo 1', 'https://youtu.be/XN1ghoDQkXw', :lower_limbs, :beginner],
    ['Membros inferiores - Idoso frágil - Vídeo 2', 'https://youtu.be/V0-HvA04e1k', :lower_limbs, :beginner],
    ['Membros inferiores - Idoso frágil - Vídeo 3', 'https://youtu.be/hnvF3fdaRUg', :lower_limbs, :beginner],
    ['Membros inferiores - Idoso frágil - Vídeo 4', 'https://youtu.be/ZcbnAjy_fHI', :lower_limbs, :beginner],
    ['Membros inferiores - Idoso frágil - Vídeo 5', 'https://youtu.be/dotudSJjVr4', :lower_limbs, :beginner],
    ['Membros inferiores - Idoso ativo - Vídeo 1', 'https://youtu.be/ZaCT9lHWFOU', :lower_limbs, :advanced],
    ['Membros inferiores - Idoso ativo - Vídeo 2', 'https://youtu.be/W51-dcwvwmY', :lower_limbs, :advanced],
    ['Membros inferiores - Idoso ativo - Vídeo 3', 'https://youtu.be/WJrz-C9EIS4', :lower_limbs, :advanced],
    ['Membros inferiores - Idoso ativo - Vídeo 4', 'https://youtu.be/x9CfTUhKHac', :lower_limbs, :advanced],
    ['Membros inferiores - Idoso ativo - Vídeo 5', 'https://youtu.be/9Ydj9lGqI5k', :lower_limbs, :advanced],
    ['Membros superiores - Idoso frágil - Vídeo 1', 'https://youtu.be/FxuhGCDpxbo', :upper_limbs, :beginner],
    ['Membros superiores - Idoso frágil - Vídeo 2', 'https://youtu.be/712gbWM1Nes', :upper_limbs, :beginner],
    ['Membros superiores - Idoso frágil - Vídeo 3', 'https://youtu.be/3KFylyV1Mn8', :upper_limbs, :beginner],
    ['Membros superiores - Idoso frágil - Vídeo 4', 'https://youtu.be/i2FOCj6d6-Y', :upper_limbs, :beginner],
    ['Membros superiores - Idoso frágil - Vídeo 5', 'https://youtu.be/cjFvWv0f6XA', :upper_limbs, :beginner],
    ['Membros superiores - Idoso ativo - Vídeo 1', 'https://youtu.be/HTx9k6rd9sM', :upper_limbs, :advanced],
    ['Membros superiores - Idoso ativo - Vídeo 2', 'https://youtu.be/VglBfL2c15I', :upper_limbs, :advanced],
    ['Membros superiores - Idoso ativo - Vídeo 3', 'https://youtu.be/GECNgHLc1Ms', :upper_limbs, :advanced],
    ['Membros superiores - Idoso ativo - Vídeo 4', 'https://youtu.be/jklsuwupW_s', :upper_limbs, :advanced],
    ['Membros superiores - Idoso ativo - Vídeo 5', 'https://youtu.be/FzNbcQZwEkk', :upper_limbs, :advanced]
  ].map do |title, url, section, level|
    { title: title, url: url, section: section, level: level }
  end

  legacy_titles = [
    'Mobilidade dos braços e ombros para iniciantes',
    'Alongamento dos braços e ombros',
    'Fortalecimento dos membros superiores',
    'Coordenação avançada de braços e ombros',
    'Mobilidade das pernas para iniciantes',
    'Alongamento das pernas e quadril',
    'Fortalecimento de pernas e joelhos',
    'Equilíbrio e estabilidade avançados',
    'Caminhada segura para iniciantes',
    'Preparação para caminhada',
    'Caminhada com resistência avançada',
    'Desafio avançado de caminhada e equilíbrio'
  ]
  Video.where(title: legacy_titles).destroy_all

videos.each do |attributes|
  video = Video.find_or_initialize_by(title: attributes[:title])
  video.assign_attributes(attributes)
  video.save!
end

puts "Seeded #{videos.size} development videos."
end

def seed_initial_research
  research = Research.find_or_initialize_by(title: 'Pesquisa inicial')
  research.save!

  option_colors = {
    turquoise: '#6ACDC3',
    blue: '#83A2E2',
    red: '#F0A1AC'
  }

  questions = [
    {
      description: 'Qual sua idade?',
      options: (50..100).map do |age|
        {
          description: age.to_s,
          color: option_colors[:turquoise],
          icon: 'numbers'
        }
      end
    },
    {
      description: 'Qual seu gênero?',
      options: [
        { description: 'Feminino', color: option_colors[:turquoise], icon: 'woman' },
        { description: 'Masculino', color: option_colors[:blue], icon: 'man' },
        { description: 'Outro', color: option_colors[:turquoise], icon: 'add' }
      ]
    },
    {
      description: 'Mora no bairro São Sebastião?',
      options: [
        { description: 'Sim', color: option_colors[:turquoise], icon: 'thumb_up' },
        { description: 'Não', color: option_colors[:red], icon: 'thumb_down' }
      ]
    },
    {
      description: 'Você mora?',
      options: [
        { description: 'Sozinho(a)', color: option_colors[:turquoise], icon: 'person' },
        { description: 'Com familiares', color: option_colors[:blue], icon: 'groups' },
        { description: 'Com cuidador', color: option_colors[:turquoise], icon: 'volunteer_activism' }
      ]
    },
    {
      description: 'Qual a sua escolaridade?',
      options: [
        { description: 'Não alfabetizado(a)', color: option_colors[:turquoise], icon: 'close' },
        { description: 'Ensino fundamental', color: option_colors[:blue], icon: 'menu_book' },
        { description: 'Ensino médio', color: option_colors[:turquoise], icon: 'domain' },
        { description: 'Ensino superior', color: option_colors[:blue], icon: 'school' }
      ]
    },
    {
      description: 'Possui alguma doença crônica (ex: hipertensão, diabetes, artrose)?',
      options: [
        {
          description: 'Sim',
          color: option_colors[:turquoise],
          icon: 'thumb_up',
          other_options: %w[Hipertensão Diabetes Artrose Osteoporose Outra]
        },
        { description: 'Não', color: option_colors[:red], icon: 'thumb_down' }
      ]
    },
    {
      description: 'Sente dores com frequência?',
      options: [
        { description: 'Sim', color: option_colors[:turquoise], icon: 'thumb_up' },
        { description: 'Não', color: option_colors[:red], icon: 'thumb_down' }
      ]
    },
    {
      description: 'Costuma praticar atividade física?',
      options: [
        {
          description: 'Sim',
          color: option_colors[:turquoise],
          icon: 'thumb_up',
          other_options: %w[Caminhada Musculação Hidroginástica Alongamento Outra]
        },
        { description: 'Não', color: option_colors[:red], icon: 'thumb_down' }
      ]
    }
  ]

  questions.each do |question_attributes|
    question = research.questions.find_or_initialize_by(
      description: question_attributes[:description]
    )
    question.save!

    question_attributes[:options].each do |option_attributes|
      option = question.options.find_or_initialize_by(
        description: option_attributes[:description]
      )
      option.assign_attributes(
        color: option_attributes[:color],
        icon: option_attributes[:icon],
        other_options: option_attributes.fetch(:other_options, [])
      )
      option.save!
    end
  end

  puts "Seeded #{questions.size} initial research questions."
end

if ENV.fetch('RACK_ENV', 'development') == 'production'
  warn 'Development seeds were not loaded in production.'
else
  seed_development_videos
  seed_initial_research
end
