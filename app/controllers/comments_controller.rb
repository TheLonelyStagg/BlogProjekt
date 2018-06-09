class CommentsController < ApplicationController

  def create
    @post = Post.find params[:post_id]
    if(logged_in?)
      @comment = @post.comments.new(comment_params)
      @comment.update_attribute(:dataiIGodz, DateTime.now)
      @comment.update_attribute(:user_id, current_user.id )
      @comment.update_attribute(:upVote, 0 )
      czy_ok = @comment.save
      if czy_ok
        flash[:notice] = 'Komentarz zostal dodany.'
      end
      redirect_to blog_post_path(params[:blog_id],@post.id)
    else
      redirect_to blog_post_path(params[:blog_id],@post.id)
    end

  end

  def destroy
    @post = Post.find params[:post_id]
    @comment = @post.comments.find(params[:id])
    if(logged_in? && (current_user.id == @post.blog.user.id || current_user.id == @comment.user.id || current_user.is_admin ))
      czy_ok = @comment.destroy
      if czy_ok
        flash[:notice] = 'Komentarz usuniety.'
      end
    end
    redirect_to blog_post_path(params[:blog_id],@post.id)
  end

  def upvote
    @user = current_user
    @comment = Comment.find params[:comment]
    if @user.voted_on? @comment
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
