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
         UserMailer.welcome_mail(@user)
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

end
