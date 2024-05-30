class VideosController < ApplicationController
  before_action :set_video, only: [:status]
  
  def status
      render json: { status: @video.conversion_status }
  end
  
  private
  
  def set_video
    @video = Video.find(params[:id])
  end
end
  