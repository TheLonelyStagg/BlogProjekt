class SessionsController < ApplicationController
  def new
    session[:back_url] = request.referrer
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    String pom = params[:session][:password]
    if user && user.password ==  pom && verify_recaptcha(message: "Potwierdź że nie jesteś robotem")
      log_in user
      flash[:notice] = 'Pomyślnie zalogowano'
      getBack

    else
      if(!flash[:recaptcha_error].blank?)
      else
        flash[:error] = 'Błędne hasło lub email'
      end
      redirect_to :action => "new"

    end
  end

  def destroy
    log_out
    flash[:notice] = 'Pomyślnie wylogowano'
    redirect_back fallback_location: root_path
  end


  def new_account
    @user = User.new
    @user.pass_confirm = ''
  end

  def create_account

    if (params[:user][:password] == params[:user][:pass_confirm] && verify_recaptcha(message: "Potwierdź że nie jesteś robotem"))
      @user = User.new(user_params_reg)
      if @user.invalid?
        if User.where('email = ?', params[:user][:email]).count != 0
          flash[:error] = 'Konto o podanym mailu już istnieje'
        else
          flash[:error] = 'Pola muszą być wypełnione'
        end

        render :action => "new_account"
        return
      end
      if params[:user][:email] == 'admin@admin.admin'
        @user.update_attribute(:is_admin, true)
      else
        @user.update_attribute(:is_admin, false)
      end


      if @user.save
        flash[:notice] = 'User zostal utworzony.'
        redirect_to login_path
      else
        flash[:error] = 'Błąd podczas rejestracji.'
        render :action => "new_account"
      end
    else
      flash[:error] = 'Błędnie powtórzone hasło.'
      render :action => "new_account"
    end
  end

  def edit_account
    if(logged_in? )
      @user = User.find(current_user.id)
      @user.new_pass = ''
      @user.pass_confirm = ''
      @user.old_pass = ''

    else
      flash[:alert] = 'Zaloguj się aby edytować swoje konto.'
      getBack
    end
  end

  def update_account
    if(logged_in?)
      @user = User.find(current_user.id)
      if (params[:user][:old_pass] == current_user.password)
        if(!(params[:user][:new_pass].blank?))
          if (params[:user][:new_pass] == params[:user][:pass_confirm])
            @user.password = params[:user][:new_pass]
          else
            flash[:error] = 'Błędnie powtórzone hasło.'
          end
        end
        if (@user.update_attributes(user_params_edt))
          if (flash[:error].blank?)
            flash[:success] = 'Uzytkownik został pomyślnie zedytowany.'
          end
          redirect_to :acton => "edit_account", :controller_name => "SessionsController"
        else
          flash[:error] = 'Bląd podczas edytowania uzytkownika.'
          redirect_to :acton => "edit_account", :controller_name => "SessionsController"
        end
      else
        flash[:error] = 'Potwierdzenie haslem wymagane.'
        redirect_to :acton => "edit_account", :controller_name => "SessionsController"
      end
    else
      flash[:alert] = 'Zaloguj się aby edytować swoje konto.'
      getBack
    end
  end

  private
  def user_params_reg
    params.require(:user).permit(:username, :password, :name, :surname, :email, :phoneNumber, :pass_confirm)
  end
  def user_params_edt
    params.require(:user).permit(:username, :name, :surname, :email, :phoneNumber, :pass_confirm, :old_pass, :new_pass)
  end
  def getBack
    if(session[:back_url].blank? )
      redirect_to blogs_path
    else
      redirect_to (session[:back_url])
    end
  end
end
