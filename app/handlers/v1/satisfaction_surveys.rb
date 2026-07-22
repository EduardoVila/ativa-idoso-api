# frozen_string_literal: true

Dir[File.join(__dir__, '..', 'concerns', '*.rb')].each do |file|
  require_relative file
end

module V1
  class SatisfactionSurveys < Sinatra::Base
    include Authenticable

    QUESTIONS = [
      {
        key: 'platform_access_score',
        description: 'Foi fácil usar a plataforma Ativa Idoso?'
      },
      {
        key: 'qr_code_access_score',
        description: 'Foi fácil acessar os vídeos pelo QR Code?'
      },
      {
        key: 'videos_understanding_score',
        description: 'Os vídeos foram fáceis de entender?'
      },
      {
        key: 'videos_motivation_score',
        description: 'Os vídeos motivaram você a fazer os exercícios?'
      }
    ].freeze

    SCORE_KEYS = SatisfactionSurveyResponse::SCORES.map(&:to_s).freeze

    get('/v1/satisfaction_surveys') do
      halt(401) unless user

      content_type :json

      response = user.satisfaction_survey_response

      status 200

      {
        submitted: response.present?,
        questions: QUESTIONS,
        response: response&.serialize_record
      }.to_json
    end

    post('/v1/satisfaction_surveys') do
      halt(401) unless user

      content_type :json

      if response_exists?
        halt 409,
             { error: 'Satisfaction survey already submitted.' }.to_json
      end

      response = SatisfactionSurveyResponse.new(
        survey_params.merge(user: user)
      )

      if response.save
        status 201

        response.serialize_record.to_json
      else
        status 422
        { errors: response.errors.full_messages }.to_json
      end
    rescue JSON::ParserError
      halt 400, { error: 'Invalid JSON body.' }.to_json
    rescue ActiveRecord::RecordNotUnique
      halt 409, { error: 'Satisfaction survey already submitted.' }.to_json
    end

    private

    def user
      @user ||= current_user(request)
    end

    def response_exists?
      user.satisfaction_survey_response.present?
    end

    def survey_params
      payload = JSON.parse(request.body.read)
      payload.slice(*SCORE_KEYS).transform_keys(&:to_sym)
    end
  end
end
