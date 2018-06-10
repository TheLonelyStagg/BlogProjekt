class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = 'User zostal utworzony.'
       redirect_to users_path
    else
       render :action => "new"
    end

   end 
  
  private
  def user_params
    params.require(:user).permit(:username, :password, :name, :surname, :email, :phoneNumber, :is_admin)
  end
end
