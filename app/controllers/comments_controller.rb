class CommentsController < ApplicationController

  def create
    @post = Post.find params[:post_id]
    @comment = @post.comments.new(comment_params)

    @comment.update_attribute(:dataiIGodz, DateTime.now)
    if(logged_in?)
      @comment.update_attribute(:user_id, current_user.id )
    else
      @comment.update_attribute(:user_id, User.last.id)
    end
    @comment.update_attribute(:upVote, 0 )
    czy_ok = @comment.save
     if czy_ok
        flash[:notice] = 'Komentarz zostal utworzony.'
     end
    redirect_to blog_post_path(params[:blog_id],@post.id)
  end


  private
  def comment_params
    params.require(:comment).permit(:dataiIGodz, :upVote, :content)
  end
end
