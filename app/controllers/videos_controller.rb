class VideosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:media_convert_callback]
  before_action :set_video_by_job_id, only: [:media_convert_callback]

  def status
    if @video.converted?
      redirect_url = diary_url(@video.diary)  # diaryのshowページへのURL
      render json: { status: 'converted', url: redirect_url }
    else
      render json: { status: 'processing' }
    end
  end

  def media_convert_callback
    @video = Video.find_by(job_id: params[:job_id])
    if @video.nil?
      render json: { status: 'error', message: 'Video not found.' }, status: :not_found
      return
    end

    if params[:status] == 'COMPLETE'
      @video.update(conversion_status: 'converted')
      render json: { status: 'success', message: 'Video converted successfully.' }
    else
      @video.update(conversion_status: 'failed')
      render json: { status: 'error', message: 'Video conversion failed.' }, status: :unprocessable_entity
    end
  end

  private

  def set_video_by_job_id
    @video = Video.find_by(media_convert_job_id: params[:job_id])
    render json: { status: 'error', message: 'Video not found.' }, status: :not_found unless @video
  end
end
