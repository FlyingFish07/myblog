class PostsController < ApplicationController
  def index
    @tag = params[:tag]
    @category = params[:category]
    page = params[:page]
    # 一般每页为5，atom的订阅为100
    limit = request.format == :atom ? 100 : Post::DEFAULT_LIMIT

    if not @tag.nil?
      @posts = Post.find_recent(:tag => @tag, :page => page, 
                                :limit => limit, :include => :tags)
    elsif not @category.nil?
      @posts = Post.find_recent(:category => @category, :page => page, 
                                :limit => limit, :include => :categories)
    else
      @posts = Post.find_recent(:page => page, :limit => limit)
    end

    raise(ActiveRecord::RecordNotFound) if @tag && @posts.empty?

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  def show
    @post = Post.find_by_permalink(*([:year, :month, :day, :slug].collect {|x| params[x] } << {:include => [:approved_comments, :tags]}))
    @comment = Comment.new
  end
end
