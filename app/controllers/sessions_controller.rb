class SessionsController < ApplicationController
  attr_accessor :login_otp, :new_login_user
  $login_otp = nil
  def new
  end
  def login_with_otp
  end
  def login_methods
  end
  def create
    user=User.find_by(email: params[:session][:email])
    $new_login_user = user
    if user && user.authenticate(params[:session][:password])
      log_in user
      ua = UserAgent.parse(request.user_agent)
      UserMailer.login_mail(user , ua , city = request.location.city).deliver!
      redirect_to user
    elsif params[:commit] == "Request otp"
      $login_otp = UsersController.generate_otp
      UserMailer.send_login_otp(user, $login_otp).deliver!
      redirect_to verify_otp_path
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
