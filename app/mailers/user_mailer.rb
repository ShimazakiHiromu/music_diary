class UserMailer < ApplicationMailer
  default from: 'info@musicdiaryapp.com'

  def activation_needed_email(user)
    @url = activate_user_users_url(token: user.activation_token)
    Rails.logger.debug "Activation URL generated: #{@url}"
    
    mail(to: user.email, subject: 'アカウントを有効化してください') do |format|
      format.text { render plain: "Music Diary Appへのご登録ありがとうございます。\n\n" \
                                "以下のリンクをクリックしてアカウントを有効化してください:\n#{@url}\n\n" \
                                "よろしくお願いいたします。\nMusic Diary App チーム" }
    end
    Rails.logger.debug "Activation email sent to: #{user.email}"
  end

  def activation_success_email(email)
    mail(to: email, subject: 'アカウントが有効化されました') do |format|
      format.text { render plain: "Music Diary Appへのアカウントが有効化されました。\n\n" \
                                "ログインはこちらから: http://localhost:3000/login\n\n" \
                                "よろしくお願いいたします。\nMusic Diary App チーム" }
    end
  end
end
