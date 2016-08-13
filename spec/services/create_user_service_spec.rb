require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../factories'

RSpec.describe CreateUserService do
  describe '#new_user' do
    it 'create user with normal role ' do
      svc = CreateUserService.new
      svc.new_user("user@test.com","password","name")
      expect(User.find_by(email: "user@test.com").role).to eq("user")
    end
  end
  describe '#new_admin' do
    it 'create user name' do
      svc = CreateUserService.new
      svc.new_admin("user@test.com","password","name")
      expect(User.find_by(email: "user@test.com").role).to eq("admin")
    end
  end
  describe '#change_user_info' do
    it 'change user name' do
      FactoryGirl.create(:user,email: "user@test.com")
      svc = CreateUserService.new
      svc.change_user_info("user@test.com","password","name",:admin)
      expect(User.find_by(email: "user@test.com").role).to eq("admin")
    end
  end
end