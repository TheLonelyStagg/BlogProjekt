class BlogsController < ApplicationController
  def index
    @blogs = Blog.all
    @users = User.all
  end
  
  def new
    if(logged_in?)
      @blog = Blog.new
    else
      flash[:alert] = 'W celu dodania blogu należy się zalogować.'
      redirect_to blogs_path
    end
  end
  
  def create

    if(logged_in?)

      @blog = Blog.new(blog_params)
      if (!@blog.name.present?)
        flash[:error] = 'Nazwa blogu jest wymagana'
        render :action => "new"
        return
      end

      if (Blog.where('name = ?', params[:blog][:name]).count != 0)
        flash[:error] = 'Blog o podanej nazwie juz istnieje'
        render :action => "new"
        return
      end

      @blog.update_attribute(:user_id, current_user.id)
      @blog.update_attribute(:dataZalozenia, Date.today)

      String rodzaje = @blog.rodzajeblogu
      rodzajepom =rodzaje.split(',')
      rodzajepom.each do |name|
        @nowyrodzaj = Kind.where(kindName: name.strip).first_or_initialize
        if @nowyrodzaj.save
        else
          flash[:error] = 'Bląd podczas dodawania blogu.'
          render :action => 'new'
        end
        @tymczasowyrodzaj = Kind.where(kindName: name.strip).first!
        @blogrodzaje = BlogKind.new
        @blogrodzaje.update_attribute(:blog_id, @blog.id)
        @blogrodzaje.update_attribute(:kind_id, @tymczasowyrodzaj.id)
        if @blogrodzaje.save
        else
          flash[:error] = 'Bląd podczas dodawania blogu.'
          render :action => 'new'
        end
      end

      if @blog.save
        flash[:success] = 'Blog został dodany.'
        redirect_to blogs_path
      else
        flash[:error] = 'Bląd podczas dodawania blogu.'
        render :action => 'new'
      end
    else
      flash[:alert] = 'W celu dodania blogu należy się zalogować.'
      redirect_to blogs_path
    end

  end

  def edit
    @blog = Blog.find(params[:id])

    if(logged_in? && (current_user.id == @blog.user.id ||  current_user.is_admin ))

      @blog.rodzajeblogu = ''

      ifpierwszy = true

      @blog.kinds.each do |rodzaj|
        if (ifpierwszy)
          @blog.rodzajeblogu = rodzaj.kindName
          ifpierwszy = false
        else
          @blog.rodzajeblogu << ", "+rodzaj.kindName
        end
      end

    else
      flash[:alert] = 'Brak odpowiednich kwalifikacji. Zaloguj się lub zmień na odpowiednie konto.'
      redirect_to blogs_path
    end
  end

  def update


    @blog = Blog.find(params[:id])
    if(logged_in? && (current_user.id == @blog.user.id ||  current_user.is_admin ))

      rodzaje = params[:blog][:rodzajeblogu]


      rodzajepom =rodzaje.split(',')
      rodzajepom.each do |name|
        @nowyrodzaj = Kind.where(kindName: name.strip).first_or_initialize
        if @nowyrodzaj.save
        else
          flash[:error] = 'Bląd podczas edytowania blogu.'
          render :action => 'edit'
        end
        @tymczasowyrodzaj = Kind.where(kindName: name.strip).first!
        @blogrodzaje = BlogKind.where(blog_id: @blog.id, kind_id: @tymczasowyrodzaj.id).first_or_initialize
        if @blogrodzaje.save
        else
          flash[:error] = 'Bląd podczas edytowania blogu.'
          render :action => 'edit'
        end
      end

      # usuwanie tych co sie nie pojawily a byly wczesniej:
      BlogKind.where(blog_id: @blog.id).each do |item|
        if (rodzajepom.map{|slowo| slowo.strip}.include? item.kind.kindName)
          # jest ok
        else
          # musimy usunac z BlogKind (zapamietuje tylko jaki rodzaj w razie usuniecia)
          rodzaj = item.kind
          if item.destroy
            #jesli usunelo ladnie to trzeba jeszcze skontrolowac czy sam rodzaj nie jest moze juz potrzebny do przechowywania
            if(rodzaj.blogs.count == 0)
              if rodzaj.destroy #jesli ladnie usunelo to ok
              else
                flash[:error] = 'Bląd podczas edytowania blogu.'
                render :action => 'edit'
              end
            end
          else
            flash[:error] = 'Bląd podczas edytowania blogu.'
            render :action => 'edit'
          end
        end
      end


      if @blog.update_attributes(blog_params)
        flash[:success] = 'Blog został pomyślnie zedytowany.'
        redirect_to blogs_path
      else
        flash[:error] = 'Bląd podczas edytowania blogu.'
        render :action => 'edit'
      end
    else
      flash[:alert] = 'Brak odpowiednich kwalifikacji. Zaloguj się lub zmień na odpowiednie konto.'
      redirect_to blogs_path
    end

  end

  def show
    redirect_to blog_posts_path(params[:id])
  end


  def bycategory
    @blog = Blog.all
    @users = User.all
    @categoryId = params[:category]
    cat_id = params[:category].to_i
    @array = []
    @blog.each do |p|
      p.kinds.each do |dif|
        if dif.id.eql?(cat_id)
          @array.push(p)
          break
        end
      end
    end
  end

  def destroy
    @blog = Blog.find(params[:id])

    if(logged_in? && (current_user.id == @blog.user.id ||  current_user.is_admin ))
      czy_ok = @blog.destroy
      if czy_ok
        # sprawdzenie i usuniecie w przypadku gdy w BlogKind zaowocuje to 0 przy count
        Kind.all.each do |item|
          if BlogKind.where('kind_id = ?', item.id).count.zero?
            if item.destroy
            else
              flash[:error] = 'Bląd podczas usuwania blogu.'
            end
          end
        end

        if flash[:error].blank?
          flash[:notice] = 'Blog został usunięty.'
        end
      else
        flash[:error] = 'Bląd podczas usuwania blogu.'
      end
    else
      flash[:alert] = 'Brak odpowiednich kwalifikacji. Zaloguj się lub zmień na odpowiednie konto.'
    end

    redirect_to blogs_path

  end

  private
  def blog_params
    params.require(:blog).permit(:dataZalozenia, :name, :status, :rodzajeblogu )
  end

end
