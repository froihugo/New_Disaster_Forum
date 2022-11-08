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
      render :new, status: :unprocessable_entity
    end

    def show
      @post = Post.find(params[:id])
    end
  end

end
