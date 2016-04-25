require File.dirname(__FILE__) + '/../spec_helper'

describe SearchController do

  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

end
