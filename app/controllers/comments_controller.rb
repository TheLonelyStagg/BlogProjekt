class CommentsController < ApplicationController

  def create
    @post = Post.find params[:post_id]
    if(logged_in?)
      @comment = @post.comments.new(comment_params)
      if (!@comment.content.present?)
        flash[:alert] = 'Komentarz musi zawierać treść'
        redirect_to blog_post_path(params[:blog_id],@post.id)
        return
      end
      @comment.update_attribute(:dataiIGodz, DateTime.now)
      @comment.update_attribute(:user_id, current_user.id )
      @comment.update_attribute(:upVote, 0 )
      czy_ok = @comment.save
      if czy_ok
        flash[:success] = 'Komentarz został dodany.'
      else
        flash[:error] = 'Bląd podczas dodawania komentarza.'
      end
      redirect_to blog_post_path(params[:blog_id],@post.id)
    else
      flash[:alert] = 'W celu dodania komentarza należy się zalogować.'
      redirect_to blog_post_path(params[:blog_id],@post.id)
    end

  end

  def destroy
    @post = Post.find params[:post_id]
    @comment = @post.comments.find(params[:id])
    if(logged_in? && (current_user.id == @post.blog.user.id || current_user.id == @comment.user.id || current_user.is_admin ))
      czy_ok = @comment.destroy
      if czy_ok
        flash[:success] = 'Komentarz usunięto z powodzeniem.'
      else
        flash[:error] = 'Błąd podczas usuwania komentarza.'
      end
    else
      flash[:alert] = 'Brak odpowiednich kwalifikacji. Zaloguj się lub zmień na odpowiednie konto.'
    end
    redirect_to blog_post_path(params[:blog_id],@post.id)
  end

  def upvote
    @user = current_user
    @comment = Comment.find params[:comment]
    if @user.voted_for? @comment
      @comment.unvote_by @user
    else
      @comment.vote_by :voter => @user
    end
    redirect_back  fallback_location: root_path
  end

  private
  def comment_params
    params.require(:comment).permit(:dataiIGodz, :upVote, :content, :comment)
  end
end
