class PostsController < ApplicationController
  def index
    @nazwa = Blog.where("id = ?", params[:blog_id]).first.name
    @posts = Post.where("blog_id = ?", params[:blog_id])
    if @posts.count>0
      posts_rest = @posts.where("posts.ifTop = 0").order("created_at DESC")
      @posts = @posts.where("posts.ifTop = 1").order("created_at DESC") + posts_rest
    end

    @blog = Blog.find params[:blog_id]
  end

  def new
    @blog = Blog.find params[:blog_id]
    if(logged_in? && (current_user.id == @blog.user.id ||  current_user.is_admin ))
      @post = Post.new
      @nazwa = Blog.where("id = ?", params[:blog_id]).first.name

    else
      flash[:alert] = 'Brak odpowiednich kwalifikacji. Zaloguj się lub zmień na odpowiednie konto.'
      redirect_to blog_posts_path
    end
  end

  def create
    @blog = Blog.find params[:blog_id]
    if(logged_in? && (current_user.id == @blog.user.id ||  current_user.is_admin ))
      @post = Post.new(post_params)
      if (!@post.title.present?)
        flash[:error] = 'Post musi mieć nazwę.'
        render :action => 'new'
        return
      end
      if (!@post.text_content.present?)
        flash[:error] = 'Post musi mieć treść.'
        render :action => 'new'
        return
      end
      @post.update_attribute(:blog_id, params[:blog_id])
      @post.update_attribute(:data, Date.today)
      @post.update_attribute(:ifTop, false)
      String tagi = @post.tagipostu
      tagpom =tagi.split(",")
      tagpom.each do |name|
        @nowytag = Tag.where(tagName: name.strip).first_or_initialize
        if @nowytag.save
        else
          flash[:error] = 'Bląd podczas dodawania postu.'
          render :action => 'new'
        end
        @tymczasowytag = Tag.where(tagName: name.strip).first!
        @posttags = PostTag.new
        @posttags.update_attribute(:post_id, @post.id)
        @posttags.update_attribute(:tag_id, @tymczasowytag.id)

        if @posttags.save
        else
          flash[:error] = 'Bląd podczas dodawania postu.'
          render :action => 'new'
        end
      end
      czy_ok = @post.save
      if czy_ok
        flash[:success] = 'Post został dodany.'
        redirect_to blog_posts_path
      else
        flash[:error] = 'Bląd podczas dodawania postu.'
        render :action => "new"
      end
    else
      flash[:alert] = 'Brak odpowiednich kwalifikacji. Zaloguj się lub zmień na odpowiednie konto.'
      redirect_to blog_posts_path
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
        # sprawdzenie i usuniecie w przypadku gdy w PostsTags zaowocuje to 0 przy count
        Tag.all.each do |item|
          if PostTag.where('tag_id = ?', item.id).count.zero?
            if item.destroy
            else
              flash[:error] = 'Bląd podczas usuwania postu.'
            end
          end
        end

        if flash[:error].blank?
          flash[:notice] = 'Post został usunięty.'
        end
      else
        flash[:error] = 'Bląd podczas usuwania postu.'
      end
    else
      flash[:alert] = 'Brak odpowiednich kwalifikacji. Zaloguj się lub zmień na odpowiednie konto.'
    end
    redirect_to blog_posts_path(params[:blog_id])
  end


  def bytags
    @posts = Post.all
    tagid = params[:tag].to_i
    @array = []
    @posts.each do |p|
      p.tags.each do |tags|
        if tags.id.equal?(tagid)
          @array.push(p)
          break
        end
      end
    end
    end

  def edit
    @nazwa = Blog.where("id = ?", params[:blog_id]).first.name

    @blog = Blog.find params[:blog_id]
    if(logged_in? && (current_user.id == @blog.user.id ||  current_user.is_admin ))

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
      flash[:alert] = 'Brak odpowiednich kwalifikacji. Zaloguj się lub zmień na odpowiednie konto.'
      redirect_to blog_posts_path(params[:blog_id])
    end

  end

  def update
    @post = Post.find params[:id]

    @blog = Blog.find params[:blog_id]
    if(logged_in? && (current_user.id == @blog.user.id ||  current_user.is_admin ))

      tagi = params[:post][:tagipostu]


      tagpom =tagi.split(',')
      tagpom.each do |name|
        @nowytag = Tag.where(tagName: name.strip).first_or_initialize
        if @nowytag.save
        else
          flash[:error] = 'Bląd podczas edytowania postu.'
          render :action => 'edit'
        end
        @tymczasowytag = Tag.where(tagName: name.strip).first!
        @posttags = PostTag.where(post_id: params[:id],tag_id: @tymczasowytag.id).first_or_initialize
        if @posttags.save
        else
          flash[:error] = 'Bląd podczas edytowania postu.'
          render :action => 'edit'
        end
      end

      # usuwanie tych co sie nie pojawily a byly wczesniej:
      PostTag.where(post_id: params[:id]).each do |item|
        if (tagpom.map{|slowo| slowo.strip}.include? item.tag.tagName)
          # jest ok
        else
          # musimy usunac z PostTag (zapamietuje tylko jaki tag w razie usuniecia)
          tagg = item.tag
          if item.destroy
            #jesli usunelo ladnie to trzeba jeszcze skontrolowac czy sam rodzaj nie jest moze juz potrzebny do przechowywania
            if(tagg.posts.count == 0)
              if tagg.destroy #jesli ladnie usunelo to ok
              else
                flash[:error] = 'Bląd podczas edytowania postu.'
                render :action => 'edit'
              end
            end
          else
            flash[:error] = 'Bląd podczas edytowania postu.'
            render :action => 'edit'
          end
        end
      end


      if @post.update_attributes(post_params)
        flash[:success] = 'Post został pomyślnie zedytowany.'
        redirect_to blog_posts_path(@post.blog.id)
      else
        flash[:error] = 'Bląd podczas edytowania postu.'
        render :action => 'edit'
      end
    else
      flash[:alert] = 'Brak odpowiednich kwalifikacji. Zaloguj się lub zmień na odpowiednie konto.'
      redirect_to blog_posts_path(params[:blog_id])
    end


  end
  
  private 
  def post_params
    params.require(:post).permit(:data, :ifTop, :text_content, :title, :tagipostu, :image)
  end

end
