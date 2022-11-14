class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :validate_post_owner, only: [:edit, :update, :destroy]

  def index
    @hot_posts = Post.order(comments_count: :desc).limit(3).select{ |post| post.comments_count >= 1 }
    @posts = Post.all
    respond_to do |format|
      format.html
      format.json { render json: @posts, each_serializer: PostSerializer }
    end
  end

  def new
    @post = Post.new
    @unique_string = sprintf "%07d", rand(0..9999999), unique: true
  end

  def create
    @post = Post.new(params[:post].permit(:title, :content, :location))
    @post.user = current_user
    if Rails.env.development?
      @post.ip_address = Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).squish
    else
      @post.ip_address = request.remote_ip
    end
    if @post.save
      flash[:notice] = 'The post was successfully saved'
      redirect_to posts_path
    else
      render :new
    end
  end

    def show
      @post = Post.find(params[:id])
      respond_to do |format|
        format.html
        format.json { render json: @post, serializer: PostSerializer }
      end
    end


  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(params.require(:post).permit(:title, :content, :location))
      redirect_to posts_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  def short_url
    @post = Post.find_by(unique_string: params[:unique_string])
    redirect_to post_path(@post)
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, category_ids: [])
  end

  def validate_post_owner
    unless @post.user == current_user
      redirect_to posts_path
    end
  end
end
