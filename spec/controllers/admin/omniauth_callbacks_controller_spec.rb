require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../../factories'

describe Admin::OmniauthCallbacksController do

  describe "handling login with valid user" do
    it "redirect to admin root" do
      stub_enki_config
      stub_env_for_omniauth
      get :open_id
      expect(response.status).to eq(302)
      expect(response).to redirect_to("/admin")
    end
    it "redirect to registe path when persist? fail" do
      user = mock_model(User)
      allow(User).to receive(:from_omniauth).and_return(user)
      allow(user).to receive(:persisted?).and_return(false)

      stub_enki_config
      stub_env_for_omniauth
      get :open_id
      expect(response.status).to eq(302)
      expect(response).to redirect_to("/")
    end
  end
  describe "handling login with invalid user" do
    it "login fail and redirection to root" do
      stub_enki_config
      stub_env_for_omniauth
      request.env["omniauth.auth"].uid = "http://evilman.com"
      get :open_id
      expect(response.status).to eq(302)
      expect(response).to redirect_to("/")
    end
  end

  def stub_enki_config
    allow(controller).to receive(:enki_config).and_return(double("enki_config", :author_open_ids => [
      "http://enkiblog.com",
      "http://secondaryopenid.com"
      ].collect {|uri| URI.parse(uri)}
      ))
  end
  def stub_env_for_omniauth
    # This a Devise specific thing for functional tests. See https://github.com/plataformatec/devise/issues/closed#issue/608
    request.env["devise.mapping"] = Devise.mappings[:user]
    env = { "omniauth.auth" => OmniAuth::AuthHash.new({ "provider" => "open_id",
     "uid" => "http://enkiblog.com", 
     "info" => {  "email" => "ghost@nobody.com" }})
  }
  request.env["omniauth.auth"] = env["omniauth.auth"]
end 
end

