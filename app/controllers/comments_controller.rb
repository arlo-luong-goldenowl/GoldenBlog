class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    @post = Post.find(params[:post_id])
    @from_page = params[:comment][:from_page]
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to posts_path
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end
end
