# frozen_string_literal: true

Dir[File.join(__dir__, 'concerns', '*.rb')].each do |file|
  require_relative file
end

module V1
  class Researches < Sinatra::Base
    include Authenticable

    get('/v1/researches/:id') do
      halt(401) unless user

      research = Research.find_by(id: params[:id])

      halt(404) unless research

      status(200)

      research.serialize_record.to_json
    end

    post('/v1/researches/:id/submit_answers') do
      halt(401) unless user

      halt(404) unless research

      save_answers
      user.update(status: :active)

      status(200)

      research.serialize_record.to_json
    end

    private

    def save_answers
      answers.each do |answer|
        question = Question.find_by(
          id: answer['question_id'], research_id: research.id
        )

        next unless question

        option = Option.find_by(
          id: answer['option_id'], question_id: question.id
        )

        next unless option

        Answer.create!(
          user_id: user.id,
          option_id: option.id,
          complement: answer['complement']
        )
      end
    end

    def user
      @user ||= current_user(request)
    end

    def answers
      @answers ||= JSON.parse(request.body.read)['answers']
    end

    def research
      @research ||= Research.find_by(id: params[:id])
    end
  end
end
