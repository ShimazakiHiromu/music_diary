# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_login, only: [:destroy]

  def new
    @user = User.new
  end

  def register_email
    email = params[:email]
    user = User.find_or_initialize_by(email: email)
  
    if user.new_record?
      user.activation_token = SecureRandom.hex(10)
      if user.save
        UserMailer.activation_needed_email(user).deliver_now
        redirect_to root_path, notice: '登録確認のメールを送信しました。'
      else
        Rails.logger.error "User save failed: #{user.errors.full_messages.join(", ")}"
        redirect_to new_user_path, alert: 'ユーザーの保存に失敗しました。'
      end
    else
      redirect_to root_path, alert: 'このメールアドレスは既に登録されています。'
    end
  end
  
  
  
  
  
  def activate
    token = params[:token]
    user = User.find_by(activation_token: token, activation_state: 'pending')
  
    if user && user.activation_token_expires_at && user.activation_token_expires_at > Time.current
      # ユーザーをactivate.html.erbに表示するためのデータを準備
      @token = token
      # ビューを表示
      render 'activate'
    else
      redirect_to root_path, alert: 'アクティベーションリンクが無効または期限切れです。'
    end
  end

  
  
  

  def complete_registration
    token = params[:token]
    user = User.find_by(activation_token: token, activation_state: 'pending')
  
    if user && user.activation_token_expires_at > Time.current
      user.assign_attributes(name: params[:name], password: params[:password], password_confirmation: params[:password_confirmation])
  
      if user.save
        user.update(activated_at: Time.current, activation_state: 'active', activation_token: nil, activation_token_expires_at: nil)
        UserMailer.activation_success_email(user.email).deliver_now
        redirect_to login_path, notice: 'アカウントが有効化されました。ログインしてください。'
      else
        # 保存に失敗した場合はエラーメッセージを設定し、フォームを再表示
        flash.now[:alert] = user.errors.full_messages.join(', ')
        render :activate, status: :unprocessableEntity
      end
    else
      redirect_to root_path, alert: '無効なアクティベーションリンクです。'
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
    params.require(:user).permit(:email)
  end
end
