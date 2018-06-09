class PostsController < ApplicationController
  def index
    @nazwa = Blog.where("id = ?", params[:blog_id]).first.name
    @posts = Post.where("blog_id = ?", params[:blog_id])
  end

  def new
    @post = Post.new
    @nazwa = Blog.where("id = ?", params[:blog_id]).first.name

  end

  def create
    @post = Post.new(post_params)
    @post.update_attribute(:blog_id, params[:blog_id])
    @post.update_attribute(:data, Date.today)
    @post.update_attribute(:ifTop, false)
    String tagi = @post.tagipostu
    tagpom =tagi.split(",")
    tagpom.each do |name|
      @nowytag = Tag.where(tagName: name.strip).first_or_initialize
      if @nowytag.save
      end
      @tymczasowytag = Tag.where(tagName: name.strip).first!
      @posttags = PostTag.new
      @posttags.update_attribute(:post_id, @post.id)
      @posttags.update_attribute(:tag_id, @tymczasowytag.id)
      @posttags.save
    end
    czy_ok = @post.save

    if czy_ok
      flash[:notice] = 'Blog zostal utworzony.'
      redirect_to blog_posts_path
    else
      render :action => "new"
    end

  end

  def show
      @blog = Blog.find params[:blog_id]
      @post = Post.find params[:id]
      @comment = @post.comments.new
      @comments = Comment.where("post_id = ?", params[:id])
      @users = User.all
  end

  def destroy
    @blog = Blog.find params[:blog_id]
    @post = Post.find params[:id]

    if(logged_in? && (current_user.id == @post.blog.user.id ||  current_user.is_admin ))
      czy_ok = @post.destroy
      if czy_ok
        flash[:notice] = 'Post usuniety.'

      end
    end
    redirect_to blog_posts_path(params[:blog_id])
  end

  def edit
    @nazwa = Blog.where("id = ?", params[:blog_id]).first.name

    if(logged_in? && (current_user.id == Blog.find(params[:blog_id]).user.id ||  current_user.is_admin ))

      @post = Post.find params[:id]

      @post.tagipostu = ''

      ifpierwszy = true

      @post.tags.each do |tagi|
        if (ifpierwszy)
          @post.tagipostu = tagi.tagName
          ifpierwszy = false
        else
          @post.tagipostu << ", "+tagi.tagName
        end
      end

    else
      redirect_to :controller =>'sessions', :action=>'new'
    end

  end

  def update
    @post = Post.find params[:id]

    if(logged_in? && (current_user.id == Blog.find(params[:blog_id]).user.id ||  current_user.is_admin ))

      tagi = params[:post][:tagipostu]


      tagpom =rodzaje.split(',')
      tagpom.each do |name|
        @nowytag = Tag.where(tagName: name.strip).first_or_initialize
        if @nowytag.save
        end
        @tymczasowytag = Tag.where(tagName: name.strip).first!
        @posttags = PostTag.where(post_id: @post.id, tag_id: @tymczasowytag.id).first_or_initialize
        @posttags.save
      end

      if @post.update_attributes(post_params)
        flash[:success] = 'Post zostal zupdateowany.'
        redirect_to blog_posts_path(@post.blog.id)
      else
        render :action => 'new'
      end
    else
      redirect_to :controller =>'sessions', :action=>'new'
    end

  end
  
  private 
  def post_params
    params.require(:post).permit(:data, :ifTop, :status, :text_content, :img_route, :title, :tagipostu)
  end

end
