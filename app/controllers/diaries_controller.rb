class DiariesController < ApplicationController
  before_action :require_login
  before_action :set_diary, only: [:show, :edit, :update, :destroy]

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
    2.times { @diary.videos.build }  # 2つの動画オブジェクトを追加
  rescue ArgumentError
    @diary = current_user.diaries.new
  end

  def edit
    (2 - @diary.videos.size).times { @diary.videos.build }
  end

  def create
    @diary = current_user.diaries.new(diary_params)
    if @diary.save
      redirect_to diary_path(@diary), notice: '日記が作成されました。'
    else
      flash[:alert] = '日記の作成に失敗しました。'
      @diary = current_user.diaries.new(date: params[:diary][:date]) # 日付を再セット
      render :new
    end
  end

  def update
    if (@diary.content.present? || @diary.videos.any?(&:attached?)) && @diary.update(diary_params)
      redirect_to diary_path(@diary), notice: '日記が更新されました。'
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
end
