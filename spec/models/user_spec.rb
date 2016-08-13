require File.dirname(__FILE__) + '/../spec_helper'

RSpec.describe User, type: :model do
  describe '.from_omniauth' do
    it 'create user name and email when can not find' do
      auth = OmniAuth::AuthHash.new({ "provider" => "open_id",
        "uid" => "http://enkiblog.com"
        })
      user = User.from_omniauth(auth)
      expect(user.email).to match(/user\w+@changeme.com/)
      expect(user.name).to match(/username\w+/)
    end
  end
end
