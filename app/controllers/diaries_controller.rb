class DiariesController < ApplicationController
  before_action :require_login
  before_action :set_diary, only: [:show, :edit, :update, :destroy]

  def index
    @diaries = current_user.diaries
    @diary_dates = @diaries.pluck(:date).map { |date| date.strftime('%Y-%m-%d') }
  end

  def show
    diary = current_user.diaries.find_by(date: params[:id].to_date)
    if diary
      @diary = diary
      render :show
    else
      redirect_to new_diary_path(date: params[:id])
    end
  end

  def new
    @diary = current_user.diaries.new(date: params[:date].to_date)
  rescue ArgumentError
    @diary = current_user.diaries.new
  end

  def edit
  end

  def create
    @diary = current_user.diaries.new(diary_params)

    if @diary.save
      redirect_to diary_path(@diary), notice: '日記が作成されました。'
    else
      render :new
    end
  end

  def update
    if @diary.update(diary_params)
      redirect_to diary_path(@diary), notice: '日記が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    if @diary
      @diary.destroy
      redirect_to diaries_url, notice: '日記が削除されました。', status: :see_other
    else
      redirect_to diaries_url, alert: '日記が見つかりません。'
    end
  end

  private

  def set_diary
    @diary = current_user.diaries.find_by(id: params[:id])
  end

  def diary_params
    params.require(:diary).permit(:date, :content)
  end
end