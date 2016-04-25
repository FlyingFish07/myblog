class Admin::PubfilesController < Admin::BaseController
  before_filter :find_pubfile, :only => [:show, :update, :destroy, :download]

  def index
    @pubfile = Pubfile.new
    @pubfiles = Pubfile.paginate(:page => params[:page]).order("created_at DESC")
  end

  def show
    respond_to do |format|
      format.html {
        render :partial => 'pubfile', :locals => {:pubfile => @pubfile} if request.xhr?
      }
    end
  end

  def create
    @pubfile = Pubfile.new(pubfile_params)
    @pubfiles = Pubfile.paginate(:page => params[:page]).order("created_at DESC")
    if @pubfile.save!
      respond_to do |format|
        format.html {
          flash[:notice] = "Uploaded File '#{@pubfile.name}'"
          redirect_to(:action => 'index', :id => @page)
        }
      end
    else
      respond_to do |format|
        format.html { render :action => 'index', :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    if @pubfile.update_attributes(pubfile_params)
      flash[:notice] = " This file has updated."
      redirect_to :action => 'index'
    else
      respond_to do |format|
        format.html { render :action => 'show', :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @pubfile.destroy
    @pubfiles = Pubfile.paginate(:page => params[:page]).order("created_at DESC")
    respond_to do |format|
      format.html do
        flash[:notice] = "This File has Deleted."
        redirect_to :action => 'index'
      end
      format.json {
        render :json => {
          :message    => "OK",
          :pubfile      => @pubfile.attributes
        }.to_json
      }
    end
  end

  def download
    send_file(@pubfile.pfile.current_path,
        :filename => @pubfile.name,
        :type => "mime/type")
  end

  private

  def pubfile_params
    params.require(:pubfile).permit(:pfile, :description)
  end

  protected

  def find_pubfile
    @pubfile = Pubfile.find(params[:id])
  end
end
