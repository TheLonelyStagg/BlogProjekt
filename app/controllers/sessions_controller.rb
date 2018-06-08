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
end
