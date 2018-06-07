class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    String pom = params[:session][:password]
    if user && user.password ==  pom
      log_in user
      flash[:notice] = 'Pomyślnie zalogowano'
      redirect_to blogs_path
    else
      flash[:danger] = 'Błędne hasło lub email'
      redirect_to :acton => "new", :controller_name => "SessionsController"

    end
  end

  def destroy
    log_out
    redirect_to blogs_path
  end
end
