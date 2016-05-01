require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../../factories'

describe Admin::PubfilesController do
  describe 'handling GET to index' do
    before(:each) do
      FactoryGirl.create(:pubfile)
      FactoryGirl.create(:pubfile, pfile: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', '美丽的sky.jpg')))
      session[:logged_in] = true
      get :index
    end

    it "is successful" do
      expect(response).to be_success
    end

    it "renders index template" do
      expect(response).to render_template('index')
    end

    it "finds pubfiles for the view" do
      expect(assigns[:pubfiles].size).to eq(2)
    end
  end

  describe 'handling GET to show' do
    before(:each) do
      @pubfile = mock_model(Pubfile)
      allow(Pubfile).to receive(:find).and_return(@pubfile)
      session[:logged_in] = true
      get :show, :id => 1
    end

    it "is successful" do
      expect(response).to be_success
    end

    it "renders show template" do
      expect(response).to render_template('show')
    end

    it "finds pubfile for the view" do
      expect(assigns[:pubfile]).to eq(@pubfile)
    end
  end

  # describe 'handling GET to new' do
  #   before(:each) do
  #     @page = mock_model(Page)
  #     allow(Page).to receive(:new).and_return(@page)
  #     session[:logged_in] = true
  #     get :new
  #   end

  #   it('is successful') { expect(response).to be_success}
  #   it('assigns page for the view') { assigns[:page] == @page }
  # end

  describe 'handling PUT to update with valid attributes' do
    before(:each) do
      @pubfile = mock_model(Pubfile, :description => 'other sky picture')
      allow(@pubfile).to receive(:update_attributes).and_return(true)
      allow(Pubfile).to receive(:find).and_return(@pubfile)
      @pfile = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'sunshine.jpg'))
    end

    def do_put
      session[:logged_in] = true
      put :update, :id => 1, :pubfile => {
        'pfile' => @pfile,
        'description'  => 'my-post'
      }
    end

    it 'updates the page' do
      expect(@pubfile).to receive(:update_attributes).with(
        'pfile' => @pfile,
        'description'  => 'my-post'
      )

      do_put
    end

    it 'it redirects to index' do
      do_put
      expect(response).to be_redirect
      expect(response).to redirect_to(admin_pubfiles_path)
    end
  end

  describe 'handling PUT to update with invalid attributes' do
    before(:each) do
      @pubfile = mock_model(Pubfile)
      allow(@pubfile).to receive(:update_attributes).and_return(false)
      allow(Pubfile).to receive(:find).and_return(@pubfile)
    end

    def do_put
      session[:logged_in] = true
      put :update, :id => 1, :pubfile => {
        'pfile' => nil,
        'description'  => 'my-post'
      }
    end

    it 'renders show' do
      do_put
      expect(response).to render_template('show')
    end

    it 'is unprocessable' do
      do_put
      expect(response.status).to eq(422)
    end
  end

  describe 'handling DELETE to delete with valid attributes' do 
     before(:each) do
      @pubfile = instance_double("pubfile")
      allow(@pubfile).to receive(:destroy).and_return(true)
      allow(Pubfile).to receive(:find).and_return(@pubfile)
    end

    def do_delete
      session[:logged_in] = true
      delete :destroy, :id => 1
    end

    it 'updates the page' do
      do_delete
      expect(@pubfile).to have_received(:destroy)
    end

    it 'it redirects to index' do
      do_delete
      expect(response).to be_redirect
      expect(response).to redirect_to(admin_pubfiles_path)
    end
  end

  describe 'handling download with valid attributes' do
    it 'should return a right file with right name' do
      pubfile1 = FactoryGirl.create(:pubfile)
      expect(@controller).to receive(:download) {
        @controller.render nothing: true # to prevent a 'missing template' error
        assigns[:pubfile].name = "sky.jpg"
      }
      session[:logged_in] = true
      get :download, :id => pubfile1.id
    end
  end
end