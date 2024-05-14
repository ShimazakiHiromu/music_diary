class DiariesController < ApplicationController
  before_action :require_login
  before_action :set_diary, only: [:show, :edit, :update, :destroy]

  def index
    @diaries = current_user.diaries.order(date: :desc)
    @diary_dates = @diaries.pluck(:date).map { |date| date.strftime('%Y-%m-%d') }
  end

  def show
    redirect_to new_diary_path(date: params[:id]) unless @diary
  end

  def new
    @diary = current_user.diaries.new(date: params[:date] ? Date.parse(params[:date]) : Date.today)
    2.times { @diary.videos.build }
  rescue ArgumentError
    @diary = current_user.diaries.new
  end

  def edit
  end

  def create
    @diary = current_user.diaries.new(diary_params)
    if @diary.save
      redirect_to @diary, notice: '日記が作成されました。'
    else
      render :new
    end
  end

  def update
    if @diary.update(diary_params)
      redirect_to @diary, notice: '日記が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @diary.destroy
    redirect_to diaries_url, notice: '日記が削除されました。'
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
    params.require(:diary).permit(:date, :content, videos_attributes: [:video_file, :artist_name, :song_title, :status])
  end
end
