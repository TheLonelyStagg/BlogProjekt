class BlogsController < ApplicationController
  def index
    @blogs = Blog.all
    @users = User.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml {render :xml => @blogs}
    end
  end
  
  def new

    if(logged_in?)
      @blog = Blog.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml {render :xml => @blog}
      end
    else
      redirect_to :controller =>'sessions', :action=>'new'
    end

  end
  
  def create

    tmp = current_user
    
    @blog = Blog.new(blog_params)
    @blog.update_attribute(:user_id, tmp.id)
    @blog.update_attribute(:dataZalozenia, Date.today)

    String rodzaje = @blog.rodzajeblogu
    rodzajepom =rodzaje.split(",")
    rodzajepom.each do |name|
      @nowyrodzaj = Kind.where(kindName: name).first_or_initialize
      if @nowyrodzaj.save
      end
      @tymczasowyrodzaj = Kind.where(kindName: name).first!
      @blogrodzaje = BlogKind.new
      @blogrodzaje.update_attribute(:blog_id, @blog.id)
      @blogrodzaje.update_attribute(:kind_id, @tymczasowyrodzaj.id)
      @blogrodzaje.save
    end
    czyok=@blog.save
    
    respond_to do |format|
      if czyok
        flash[:notice] = 'Blog zostal utworzony.'
        format.html { redirect_to blogs_path  }
        format.xml  { render :xml => @blog, :status => :created, :location => @blog }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
    
   end

  def show
    redirect_to blog_posts_path(params[:id])
  end

  private
  def blog_params
    params.require(:blog).permit(:dataZalozenia, :name, :status, :rodzajeblogu )
  end

end
