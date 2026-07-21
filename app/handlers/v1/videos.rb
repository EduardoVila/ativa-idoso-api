# frozen_string_literal: true

Dir[File.join(__dir__, 'concerns', '*.rb')].each do |file|
  require_relative file
end

module V1
  class Videos < Sinatra::Base
    include Authenticable

    get('/v1/videos') do
      halt(401) unless user

      videos = Video.where(section: params[:section])

      status(200)

      videos.map do |video|
        video.serialize_record.merge(
          view: view(video.id)
        )
      end.to_json
    end

    post('/v1/videos/:id/views') do
      halt(401) unless user

      video = Video.find_by(id: params[:id])

      halt(404) unless video

      view = View.find_or_initialize_by(user_id: user.id, video_id: video.id)

      view.percentage_watched = params[:percentage_watched]
      view.watched_completely = params[:percentage_watched] == 100

      view.save!

      status(200)

      view.serialize_record.to_json
    end

    private

    def view(video_id)
      view = View.find_by(user_id: user.id, video_id: video_id)

      return {} unless view

      view.serialize_record
    end

    def user
      @user ||= current_user(request)
    end
  end
end
