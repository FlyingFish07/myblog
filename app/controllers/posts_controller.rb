class PostsController < ApplicationController
  def index
    @tag = params[:tag]
    @category = params[:category]
    page = params[:page]
    if not @tag.nil?
      @posts = Post.find_recent(:tag => @tag, :page => page, :include => :tags)
    elsif not @category.nil?
      @posts = Post.find_recent(:category => @category, :page => page, :include => :categories)
    else
      @posts = Post.find_recent(:page => page)
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
