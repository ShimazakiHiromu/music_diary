# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_login, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: 'ユーザー登録が完了しました。'
    else
      render :new
    end
  end

  def destroy
    user = current_user
    if user.destroy
      logout
      redirect_to root_path, notice: 'アカウントが削除されました。'
    else
      redirect_to root_path, alert: 'アカウントの削除に失敗しました。'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
