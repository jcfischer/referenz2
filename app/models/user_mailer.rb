class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Bitte aktiviere deinen neuen Account'

    @body[:url]  = "http://#{APPLICATION['site_host']}/activate/#{user.activation_code}"

  end

  def activation(user)
    setup_email(user)
    @subject    += 'Dein Account wurde aktiviert!'
    @body[:url]  = "http://#{APPLICATION['site_host']}/"
  end

  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = APPLICATION['admin_email']
    @subject     = "[#{APPLICATION['app_name']}] "
    @sent_on     = Time.now
    @body[:user] = user
  end
end

