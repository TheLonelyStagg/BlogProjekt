class UsersController < ApplicationController
  def index
    @users = User.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml {render :xml => @users}
    end
  end
  
  def new
    @user = User.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml {render :xml => @user}
    end
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
