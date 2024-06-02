class VideosController < ApplicationController
  before_action :set_video, only: [:status]

  def status
    Rails.logger.info "Video: #{@video}, Content Type: #{@video&.video_file&.blob&.content_type}"
    if @video.converted?
      Rails.logger.info "Video is converted."
      redirect_url = diary_url(@video.diary)  # diaryのshowページへのURL
      render json: { status: 'converted', url: redirect_url }
    else
      Rails.logger.info "Video is still processing."
      render json: { status: 'processing' }
    end
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end
end
