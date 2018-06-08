class PostsController < ApplicationController
  def index
    @nazwa = Blog.where("id = ?", params[:blog_id]).first.name
    @posts = Post.where("blog_id = ?", params[:blog_id])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml {render :xml => @posts}
    end
  end

  def new
    @post = Post.new
    @nazwa = Blog.where("id = ?", params[:blog_id]).first.name

    respond_to do |format|
      format.html # new.html.erb
      format.xml {render :xml => @post}
    end
  end

  def create
    @post = Post.new(post_params)
    @post.update_attribute(:blog_id, params[:blog_id])
    @post.update_attribute(:data, Date.today)
    @post.update_attribute(:ifTop, false)
    String tagi = @post.tagipostu
    tagpom =tagi.split(",")
    tagpom.each do |name|
      @nowytag = Tag.where(tagName: name).first_or_initialize
      if @nowytag.save
      end
      @tymczasowytag = Tag.where(tagName: name).first!
      @posttags = PostTag.new
      @posttags.update_attribute(:post_id, @post.id)
      @posttags.update_attribute(:tag_id, @tymczasowytag.id)
      @posttags.save
    end
    czy_ok = @post.save

    respond_to do |format|
      if czy_ok
        flash[:notice] = 'Blog zostal utworzony.'
        format.html { redirect_to blog_posts_path  }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
      @post = Post.find params[:id]
      respond_to do |format|
        format.html # show.html.erb
        format.xml {render :xml => @post}
      end
    end
  
  private 
  def post_params
    params.require(:post).permit(:data, :ifTop, :status, :text_content, :img_route, :title, :tagipostu)
  end

end
