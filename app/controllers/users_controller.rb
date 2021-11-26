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

  def generate_otp
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
        @@otp = generate_otp
        @@target = user
        @@p1 = params[:password_reset][:password]
        @@p2 = params[:password_reset][:password_confirmation]
        UserMailer.otp_verify(user, @@otp).deliver!
        redirect_to verify_otp_path
        #redirect_to login_path
      else
        flash[:password_mismatch] = 'Password confirmation not matched'
        redirect_to password_reset_path
      end
    end
  end

  def otp_check
    if @@otp == params[:otp_verify][:user_given_otp].to_i
       @@target.update(:password => @@p1,:password_confirmation => @@p2)
       redirect_to login_path
       flash[:otp_sucess] = 'Password changed successfully you can login with your new password'
    else
       flash[:otp_fail] = 'entered otp is incorrect and we had sent you new otp via mail please use that '
       redirect_to verify_otp_path
       @@otp = generate_otp
       UserMailer.otp_verify(@@target, @@otp).deliver!
    end
  end


end
