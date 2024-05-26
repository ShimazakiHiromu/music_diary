# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
  end

  def create
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      redirect_to root_path, notice: 'ログインしました。'  # ここを修正
    else
      # ユーザーの存在確認
      found_user = User.find_by(email: params[:email])
      if found_user
        if found_user.activation_state == 'active'
          logger.error "Login failed for email: #{params[:email]}, Password mismatch."
        else
          logger.error "Login failed for email: #{params[:email]}, User not activated."
        end
      else
        logger.fatal "No user found with email: #{params[:email]}"
      end
  
      flash.now[:alert] = 'ログインに失敗しました。'
      render :new
    end
  end
  



  def destroy
    logout
    redirect_to root_path, notice: 'ログアウトしました。', status: :see_other
  end
end
