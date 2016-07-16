class Admin::PubimagesController < Admin::BaseController
  before_filter :find_pubimage, :only => [:show, :update, :destroy, :download]
  before_filter :get_pubimages_for_index, :only => [:index, :create, :destroy]
  after_action :verify_authorized, except: [:index, :create, :download]
  after_action :verify_policy_scoped, only: [:index, :create, :destroy]

  def index
    @pubimage = Pubimage.new
  end

  def create
    @pubimage = Pubimage.new(pubimage_params)
    @pubimage.user_id = current_user.id
    if @pubimage.save!
      respond_to do |format|
        format.html {
          flash[:notice] = "Uploaded File '#{@pubimage.name}'"
          redirect_to(:action => 'index', :id => @page)
        }
      end
    else
      respond_to do |format|
        format.html { render :action => 'index', :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    authorize @pubimage
    @pubimage.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = "This File has Deleted."
        redirect_to :action => 'index'
      end
      format.json {
        render :json => {
          :message    => "OK",
          :pubimage      => @pubimage.attributes
        }.to_json
      }
    end
  end

  def download
    send_file(@pubimage.pimage.current_path,
        :filename => @pubimage.name,
        :type => "mime/type")
  end

  private

  def pubimage_params
    params.require(:pubimage).permit(:pimage)
  end

  def get_pubimages_for_index
    @pubimages = policy_scope(Pubimage.paginate(:page => params[:page]).order("created_at DESC"))
  end

  protected

  def find_pubimage
    @pubimage = Pubimage.find(params[:id])
  end
end
