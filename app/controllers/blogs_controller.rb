class BlogsController < ApplicationController
  def index
    @blogs = Blog.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml {render :xml => @blogs}
    end
  end
  
  def new
    @blog = Blog.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml {render :xml => @blog}
    end
  end
  
  def create
    
    tmp = User.last
    
    @blog = Blog.new(blog_params)
    @blog.update_attribute(:user_id, tmp.id)
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
  
  private
  def blog_params
    params.require(:blog).permit(:dataZalozenia, :name, :status )
  end
  
  def show
    
  end
  
  
end
