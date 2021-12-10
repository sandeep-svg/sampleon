class UsersController < ApplicationController
  def show
    @user=User.find(params[:id])
  end
  def new
    @user=User.new
  end
  def index
    @user=User.all
  end
  def create
      @user=User.new(params.require(:user).permit(:name, :email, :password, :password_confirmation))
      if @user.save
         flash[:notice] = "Account created successfully!!"
          UserMailer.welcome_mail(@user).deliver!
          redirect_to login_path
       else
         render 'new'
      end
  end
  def edit
    @user = User.find(params[:id])
  end
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params.require(:user).permit(:name, :email, :password, :password_confirmation))
      flash[:note2]='details updated successfully 11'
      redirect_to @user
    else
      render 'edit'
    end
  end
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def password_reset
  end

  def self.generate_otp
    otp = []
    for i in 1..6
        otp << rand(9)
    end
    return otp.join().to_i
  end

  def otp_verify
  end

  def update_password
    user = User.where(email: params[:password_reset][:email]).first
    if user.nil?
      flash[:no_user] = 'User not exist'
      redirect_to password_reset_path
    else
      if params[:password_reset][:password] == params[:password_reset][:password_confirmation]
        otp = self.class.generate_otp
        Rails.cache.write(session['session_id']+'forgot_password_user',{user => otp},expires_in: 3.minute)
        Rails.cache.write(session['session_id']+'forgot_password_user_params',{'p1' => params[:password_reset][:password],'p2' => params[:password_reset][:password_confirmation]},expires_in: 3.minute)
        UserMailer.otp_verify(user, otp).deliver!
        flash[:mail_otp_sucess] = 'otp has sent to your registered mail '
        redirect_to verify_otp_path
        #redirect_to login_path
      else
        flash[:password_mismatch] = 'Password confirmation not matched'
        redirect_to password_reset_path
      end
    end
  end

  def otp_check
    user = Rails.cache.read(session['session_id']).nil? ? nil : Rails.cache.read(session['session_id']).keys.first
    target = Rails.cache.read(session['session_id']+'forgot_password_user').nil? ? nil : Rails.cache.read(session['session_id']+'forgot_password_user').keys.first
    forgot_pass_otp = Rails.cache.read(session['session_id']+'forgot_password_user').nil? ? nil : Rails.cache.read(session['session_id']+'forgot_password_user').values.first
    if forgot_pass_otp == params[:otp_verify][:user_given_otp].to_i
       target.update(:password => Rails.cache.read(session['session_id']+'forgot_password_user_params').values[0],:password_confirmation => Rails.cache.read(session['session_id']+'forgot_password_user_params').values[1]) unless target.nil?
       Rails.cache.delete(session['session_id']+'forgot_password_user')
       Rails.cache.delete(session['session_id']+'forgot_password_user_params')
       redirect_to login_path
       flash[:otp_sucess] = 'Password changed successfully you can login with your new password'
    elsif Rails.cache.read(session['session_id'])
      if Rails.cache.read(session['session_id']).values.first == params[:otp_verify][:user_given_otp].to_i
        Rails.cache.delete(session['session_id'])
        log_in user
        ua = UserAgent.parse(request.user_agent)
        UserMailer.login_mail(user , ua , city = request.location.city).deliver!
        redirect_to user
      else
        login_otp = self.class.generate_otp
        Rails.cache.write(session['session_id'],{user=>login_otp},expires_in: 3.minute)
        UserMailer.send_login_otp(user, login_otp).deliver!
        flash[:login_with_otp_failed] = 'Entered Otp is incorrect please use new otp we just sent to your mail'
        redirect_to verify_otp_path
      end
    else
       flash[:otp_fail] = 'entered otp is incorrect and we had sent you new otp via mail please use that '
       
       otp = self.class.generate_otp unless target.nil?
       if target.nil?
         redirect_to root_path
       else
        redirect_to verify_otp_path
       end
       Rails.cache.write(session['session_id']+'forgot_password_user',{user => otp},expires_in: 3.minute)
       UserMailer.otp_verify(target, otp).deliver! unless target.nil?
    end
  end


end
