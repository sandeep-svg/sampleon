class SessionsController < ApplicationController
  def new
  end
  def create
    user=User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
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
