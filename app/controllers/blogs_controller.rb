class BlogsController < ApplicationController
  def index
    @blogs = Blog.all
    @users = User.all
  end
  
  def new
    if(logged_in?)
      @blog = Blog.new
    else
      redirect_to :controller =>'sessions', :action=>'new'
    end
  end
  
  def create

    if(logged_in?)

      @blog = Blog.new(blog_params)
      @blog.update_attribute(:user_id, current_user.id)
      @blog.update_attribute(:dataZalozenia, Date.today)

      String rodzaje = @blog.rodzajeblogu
      rodzajepom =rodzaje.split(',')
      rodzajepom.each do |name|
        @nowyrodzaj = Kind.where(kindName: name.strip).first_or_initialize
        if @nowyrodzaj.save
        end
        @tymczasowyrodzaj = Kind.where(kindName: name.strip).first!
        @blogrodzaje = BlogKind.new
        @blogrodzaje.update_attribute(:blog_id, @blog.id)
        @blogrodzaje.update_attribute(:kind_id, @tymczasowyrodzaj.id)
        @blogrodzaje.save
      end

      if @blog.save
        flash[:success] = 'Blog zostal utworzony.'
        redirect_to blogs_path
      else
        render :action => 'new'
      end
    else
      redirect_to :controller =>'sessions', :action=>'new'
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
      redirect_to :controller =>'sessions', :action=>'new'
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
        end
        @tymczasowyrodzaj = Kind.where(kindName: name.strip).first!
        @blogrodzaje = BlogKind.where(blog_id: @blog.id, kind_id: @tymczasowyrodzaj.id).first_or_initialize
        @blogrodzaje.save
      end

      if @blog.update_attributes(blog_params)
        flash[:success] = 'Blog zostal zupdateowany.'
        redirect_to blogs_path
      else
        render :action => 'new'
      end
    else
      redirect_to :controller =>'sessions', :action=>'new'
    end

  end

  def show
    redirect_to blog_posts_path(params[:id])
  end


  def bycategory
    @blog = Blog.all
    @users = User.all
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
        flash[:notice] = 'Blog usuniety.'

      end
    end
    redirect_to blogs_path

  end

  private
  def blog_params
    params.require(:blog).permit(:dataZalozenia, :name, :status, :rodzajeblogu )
  end

end
