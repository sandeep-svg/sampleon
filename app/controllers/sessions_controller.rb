class SessionsController < ApplicationController
  attr_accessor :user_flag
  @@user_flag = nil
  def new
  end
  def login_with_otp
    if @@user_flag
      flash[:invalid_user] = 'User not exist'
      @@user_flag = nil
    end
  end
  def login_methods
  end
  def create
    user=User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in user
      ua = UserAgent.parse(request.user_agent)
      UserMailer.login_mail(user , ua , city = request.location.city).deliver!
      redirect_to user
    elsif params[:commit] == "Request otp"
      if user.nil?
        @@user_flag = true
        redirect_to login_otp_path
      else
        @@user_flag = nil
        login_otp = UsersController.generate_otp
        Rails.cache.write(session['session_id'],{user=>login_otp},expires_in: 3.minute)
        UserMailer.send_login_otp(user, login_otp).deliver!
        flash[:login_otp_sent_sucess] = 'Otp sent sucessfully.'
        redirect_to verify_otp_path
      end
    else
      flash[:danger]='    invalid credentials!!'
      render 'new'
    end 
  end
  def destroy
    log_out
    flash[:note1]='you have been logged out of the session!! '
    redirect_to root_url
  end
end
