class UserMailer < ApplicationMailer
  default from: "welcomemailfromsampleapp@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation
    @greeting = "Hi"

    mail to: "to@example.org"
  end
  def welcome_mail(user)
    @user=user
    mail to: @user.email , subject: 'Welcome mail' 
  end

  def document(user)
    @user=user
    attachments['data.csv'] = File.read('tmp/sample1.csv')
    mail to: @user.email , subject: 'Attachment' 
  end

  def login_mail(user)
    @user=user
    mail to: @user.email , subject: 'Login Alert' 
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
