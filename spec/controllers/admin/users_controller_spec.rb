require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../../factories'

describe Admin::UsersController do
  describe 'handling GET to index' do
    before(:each) do
      admin_users = FactoryGirl.create_list(:admin, 2)
      sign_in admin_users[0]
      get :index
    end

    it "is successful" do
      expect(response).to be_success
    end

    it "renders index template" do
      expect(response).to render_template('index')
    end

    it "finds posts for the view" do
      expect(assigns[:users].size).to be 2
      expect(assigns[:users][0]).to be_a_kind_of(User)
      expect(assigns[:users][1]).to be_a_kind_of(User)
    end
  end

  describe 'handling GET to show' do
    before(:each) do
      @user = mock_model(User)
      allow(User).to receive(:find).and_return(@user)
      sign_in FactoryGirl.create(:admin)
      get :show, :id => 1
    end

    it "is successful" do
      expect(response).to be_success
    end

    it "renders show template" do
      expect(response).to render_template('show')
    end

    it "finds user for the view" do
      expect(assigns[:user]).to eq(@user)
    end
  end

  describe 'handling PUT to update with valid attributes' do
    before(:each) do
      @user = mock_model(User, :name => 'new name')
      allow(@user).to receive(:update_attributes).and_return(true)
      allow(User).to receive(:find).and_return(@user)
    end

    def do_put
      sign_in FactoryGirl.create(:admin)
      put :update, :id => 1, :user => {
        'name'         => "My Name",
        'email'        => "hello@test.com",
      }
    end

    it 'updates the user' do
      expect(@user).to receive(:update_attributes).with({'name' => "My Name"})
      do_put
    end

    it 'it redirects to root' do
      do_put
      expect(response).to be_redirect
      expect(response).to redirect_to(admin_root_path)
    end
  end

  describe 'handling PUT to update with invalid attributes' do
    before(:each) do
      @user = mock_model(User)
      allow(@user).to receive(:update_attributes).and_return(false)
      allow(User).to receive(:find).and_return(@user)
    end

    def do_put
      sign_in FactoryGirl.create(:admin)
      put :update, :id => 1, :user => valid_user_attributes
    end

    it 'redirects to root' do
      do_put
      expect(response).to redirect_to(admin_root_path)
    end

    it 'show alert message' do
      do_put
      expect(flash.now[:alert]).not_to be_nil
    end
  end

  def valid_user_attributes
    {
      'name'         => "My Name",
      'email'        => "hello@test.com",
    }
  end

  describe 'handling DELETE to destroy' do
    before(:each) do
      @user = User.new
      allow(@user).to receive(:destroy_with_undo)
      allow(User).to receive(:find).and_return(@user)
    end

    def do_delete
      sign_in FactoryGirl.create(:admin)
      delete :destroy, :id => 1
    end

    it("redirects to index") do
      do_delete
      expect(response).to be_redirect
      expect(response).to redirect_to(admin_root_path)
    end
  end

  describe 'handling edit_for_omniauth' do
    describe 'the user is omniauth user' do
      before(:each) do
        ominauth_user = FactoryGirl.create(:user, 
        provider: 'open_id',uid: 'http://hello_openid.com')
        sign_in ominauth_user
        get :edit_for_omniauth, :id => ominauth_user.id
      end
      it "is successful" do
        expect(response).to be_success
      end
      it "render edit_for_omniauth" do
        expect(response).to render_template('edit_for_omniauth')
      end
    end
    describe 'the user is not omniauth user' do
      it "throw an exception" do
        normal_user = FactoryGirl.create(:user)
        sign_in normal_user
        expect { get :edit_for_omniauth, :id => normal_user.id }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
  
  describe 'handling PUT to update_for_omniauth with valid attributes' do
    before(:each) do
      @user = FactoryGirl.create(:user, 
        provider: 'open_id',uid: 'http://hello_openid.com')
      allow(@user).to receive(:update_attributes).and_return(true)
      allow(User).to receive(:find).and_return(@user)
    end

    def do_put
      sign_in @user
      put :update_for_omniauth, :id => 1, :user => {
        'name'         => "My Name",
        'email'        => "hello@test.com",
      }
    end

    it 'updates the user' do
      expect(@user).to receive(:update_attributes).with({'name' => "My Name"})
      do_put
    end

    it 'it redirects to root' do
      do_put
      expect(response).to be_redirect
      expect(response).to redirect_to(admin_root_path)
    end
  end

  describe 'handling PUT to update_for_omniauth with invalid attributes' do
    before(:each) do
      @user = FactoryGirl.create(:user, 
        provider: 'open_id',uid: 'http://hello_openid.com')
      allow(@user).to receive(:update_attributes).and_return(false)
      allow(User).to receive(:find).and_return(@user)
    end

    def do_put
      sign_in @user
      put :update_for_omniauth, :id => 1, :user => valid_user_attributes
    end

    it 'redirects to root' do
      do_put
      expect(response).to redirect_to(admin_root_path)
    end

    it 'show alert message' do
      do_put
      expect(flash.now[:alert]).not_to be_nil
    end
  end
  describe '#update_for_omniauth' do
    describe 'the user is not omniauth user' do
      it "throw an exception" do
        normal_user = FactoryGirl.create(:user)
        sign_in normal_user
        expect { get :update_for_omniauth, :id => normal_user.id }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end

