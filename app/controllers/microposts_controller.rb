class MicropostsController < ApplicationController
    def show
        @user = User.find(params[:id])
      end
      before_action :logged_in_user, only: [:create, :destroy]

      def create
        @micropost = current_user.microposts.build(params.require(:micropost).permit(:content))
        if @micropost.save
          flash[:success] = "Micropost created!"
          redirect_to root_path
        else
          render 'static_pages/home'
        end
      end
      def destroy
      end
      def new
        @micropost=microposts.new
      end
end
