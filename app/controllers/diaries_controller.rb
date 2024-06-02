class DiariesController < ApplicationController
  before_action :require_login
  before_action :set_diary, only: [:show, :edit, :update, :destroy, :processing]

  def index
    @diaries = current_user.diaries
    @diary_dates = @diaries.pluck(:date).map { |date| date.strftime('%Y-%m-%d') }
  end

  def show
    if !@diary
      redirect_to new_diary_path(date: params[:id])
    end
  end

  def new
    @diary = current_user.diaries.new(date: params[:date].to_date)
    2.times { @diary.videos.build }
  rescue ArgumentError
    @diary = current_user.diaries.new
  end

  def edit
    (2 - @diary.videos.size).times { @diary.videos.build }
  end

  def create
    @diary = current_user.diaries.new(diary_params)
    if @diary.save
      process_videos(@diary)
      if @diary.videos.any? { |video| video.conversion_status == "processing" }
        redirect_to processing_diary_path(@diary)  # ビデオ変換待機ページにリダイレクト
      else
        redirect_to diary_path(@diary)  # 全てのビデオが即座に変換されていれば、日記の詳細ページにリダイレクト
      end
    else
      flash[:alert] = '日記の作成に失敗しました。'
      render :new
    end
  end
  

  def update
    if @diary.update(diary_params)
      @diary.videos.each do |video|
        if video.video_file.attached? && video.video_file.content_type == 'video/quicktime'
          VideoConverterJob.perform_later(video)
        end
      end
      redirect_to diary_path(@diary)  # 日記の詳細ページに直接リダイレクト
    else
      flash[:alert] = '日記の更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    @diary.destroy
    redirect_to diaries_url, notice: '日記が削除されました。', status: :see_other
  end

  def redirect_to_diary_or_new
    diary = current_user.diaries.find_by(date: params[:date])
    if diary
      redirect_to diary_path(diary)
    else
      redirect_to new_diary_path(date: params[:date])
    end
  end

  private

  def set_diary
    @diary = current_user.diaries.find_by(id: params[:id])
  end

  def diary_params
    params.require(:diary).permit(:date, :content, videos_attributes: [:id, :video_file, :artist_name, :song_title, :status, :_destroy])
  end

  def process_videos(diary)
    diary.videos.each do |video|
      if video.video_file.content_type != 'video/mp4'
        VideoConverterJob.perform_later(video)
        video.update(conversion_status: "processing")
      else
        video.update(conversion_status: "converted")
      end
    end
  end
end
