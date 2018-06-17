class UsersController < ApplicationController
  def index
    if(logged_in? &&  current_user.is_admin )
    @users = User.all
    else
      flash[:alert] = 'Brak odpowiednich kwalifikacji. Zaloguj się lub zmień na odpowiednie konto.'
      redirect_to blogs_path
    end
  end
  
  def new
    if(logged_in? &&  current_user.is_admin )
    @user = User.new
    else
      flash[:alert] = 'Brak odpowiednich kwalifikacji. Zaloguj się lub zmień na odpowiednie konto.'
      redirect_to blogs_path
    end
  end
  
  def create
    if(logged_in? &&  current_user.is_admin )
      @user = User.new(user_params)

      if @user.save
        flash[:notice] = 'User zostal utworzony.'
        redirect_to users_path
      else
        render :action => "new"
      end
    else
      flash[:alert] = 'Brak odpowiednich kwalifikacji. Zaloguj się lub zmień na odpowiednie konto.'
      redirect_to blogs_path
    end
  end

  def destroy
    if(logged_in? && current_user.is_admin )
      @user = User.find(params[:id])
      czy_ok = @user.destroy
      if czy_ok
        flash[:notice] = 'Uzytkownik został usunięty.'
      else
        flash[:error] = 'Bląd podczas usuwania uzytkownika.'
      end
      redirect_to users_path
    else
      flash[:alert] = 'Brak odpowiednich kwalifikacji. Zaloguj się lub zmień na odpowiednie konto.'
      redirect_to blogs_path
    end

  end


  def edit
    if(logged_in? &&  current_user.is_admin )
      @user = User.find(params[:id])
    else
      flash[:alert] = 'Brak odpowiednich kwalifikacji. Zaloguj się lub zmień na odpowiednie konto.'
      redirect_to blogs_path
    end
  end

  def update
    if(logged_in? && current_user.is_admin)
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
        flash[:success] = 'Uzytkownik został pomyślnie zedytowany.'
        redirect_to users_path
      else
        flash[:error] = 'Bląd podczas edytowania uzytkownika.'
        render :action => 'edit'
      end
    else
      flash[:alert] = 'Brak odpowiednich kwalifikacji. Zaloguj się lub zmień na odpowiednie konto.'
      redirect_to blogs_path
    end

  end


  private
  def user_params
    params.require(:user).permit(:username, :password, :name, :surname, :email, :phoneNumber, :is_admin)
  end
end
