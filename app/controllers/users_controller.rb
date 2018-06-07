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

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User zostal utworzony.'
        format.html { redirect_to users_path }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
    
   end 
  
  private
  def user_params
    params.require(:user).permit(:username, :password, :name, :surname, :email, :phoneNumber)
  end
end
