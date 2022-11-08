class PostsController < ApplicationController

  def index
    @posts = Post.all
  end

  def new
    @posts = Post.new
  end

  def create
    post = Post.new(params[:post].permit(:title, :content, :location))
    if post.save
      redirect_to posts_path
    else
    end
  end

end
