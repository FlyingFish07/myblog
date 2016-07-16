class Admin::CommentsController < Admin::BaseController
  before_filter :find_comment, :only => [:show, :view, :update, :destroy]
  after_action :verify_authorized, except: [:index, :show, :view]
  after_action :verify_policy_scoped, only: :index

  def index
    @comments = policy_scope(Comment.paginate(:page => params[:page]).includes(:post).order("comments.created_at DESC"))
  end

  def show
    respond_to do |format|
      format.html {
        render :partial => 'show', :locals => {:comment => @comment} if request.xhr?
      }
    end
  end

  def view 
  end

  def update
    authorize @comment
    if @comment.update_attributes(comment_params)
      flash[:notice] = "Updated comment by #{@comment.author}"
      redirect_to :action => 'index'
    else
      render :action => 'show'
    end
  end

  def destroy
    authorize @comment
    undo_item = @comment.destroy_with_undo(current_user)

    respond_to do |format|
      format.html do
        flash[:notice] = "Deleted comment by #{@comment.author}"
        redirect_to :action => 'index'
      end
      format.json {
        render :json => {
          :undo_path    => undo_admin_undo_item_path(undo_item),
          :undo_message => undo_item.description,
          :comment      => @comment.attributes
        }.to_json
      }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:author, :author_url, :author_email, :body)
  end

  protected

  def find_comment
    @comment = Comment.find(params[:id])
  end
end
