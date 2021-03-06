class Admin::PostsController < Admin::BaseController
  before_filter :find_post, :only => [:show, :update, :destroy]
  after_action :verify_authorized, except: [:index, :create, :show, :new, :preview]
  after_action :verify_policy_scoped, only: :index

  def index
    respond_to do |format|
      format.html {
        @posts = policy_scope(Post.paginate(:page => params[:page]).order("coalesce(published_at, updated_at) DESC")) 
      }
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      respond_to do |format|
        format.html {
          flash[:notice] = "Created post '#{@post.title}'"
          redirect_to(:action => 'show', :id => @post)
        }
      end
    else
      respond_to do |format|
        format.html { render :action => 'new', :status => :unprocessable_entity }
      end
    end
  end

  def update
    authorize @post
    if @post.update_attributes(post_params)
      respond_to do |format|
        format.html {
          flash[:notice] = "Updated post '#{@post.title}'"
          redirect_to(:action => 'show', :id => @post)
        }
      end
    else
      respond_to do |format|
        format.html { render :action => 'show', :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html {
        render :partial => 'post', :locals => {:post => @post} if request.xhr?
      }
    end
  end

  def new
    @post = Post.new
  end

  def preview
    @post = Post.build_for_preview(post_params)

    respond_to do |format|
      format.js {
        render :partial => 'posts/post', :locals => {:post => @post}
      }
    end
  end

  def destroy
    authorize @post
    undo_item = @post.destroy_with_undo(current_user)

    respond_to do |format|
      format.html do
        flash[:notice] = "Deleted post '#{@post.title}'"
        redirect_to :action => 'index'
      end
      format.json {
        render :json => {
          :undo_path    => undo_admin_undo_item_path(undo_item),
          :undo_message => undo_item.description,
          :post         => @post.attributes
        }
      }
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :category_list, :tag_list, :published_at_natural, :slug, :minor_edit)
  end

  protected

  def find_post
    @post = Post.find(params[:id])
  end

end
