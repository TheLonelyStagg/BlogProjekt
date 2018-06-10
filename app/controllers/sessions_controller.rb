class SessionsController < ApplicationController
  def new
    session[:back_url] = request.referrer
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    String pom = params[:session][:password]
    if user && user.password ==  pom
      log_in user
      flash[:notice] = 'Pomyślnie zalogowano'
      if(session[:back_url].blank?)
        redirect_to blogs_path
      else
        redirect_to (session[:back_url])
      end

    else
      flash[:danger] = 'Błędne hasło lub email'
      redirect_to :acton => "new", :controller_name => "SessionsController"

    end
  end

  def destroy
    log_out
    redirect_back fallback_location: root_path
  end


  def new_account
    @user = User.new
  end

  def create_account
    @user = User.new(user_params)
    @user.update_attribute(:is_admin, false)

    if @user.save
      flash[:notice] = 'User zostal utworzony.'
      redirect_to login_path
    else
      render :action => "new_account"
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :password, :name, :surname, :email, :phoneNumber)
  end
end
