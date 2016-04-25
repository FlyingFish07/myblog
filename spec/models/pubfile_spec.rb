require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../factories'

describe Pubfile do

  it "should save ok with right name and url" do
     pubfile1 = FactoryGirl.create(:pubfile)
     expect(pubfile1.pfile.url).to eq("/uploads/pubfiles/sunshine.jpg")
     expect(pubfile1.name).to eq("sunshine.jpg")
     expect(pubfile1.description).to eq("it is very beautiful")
  end

  it "should save ok with right pinyin name and url" do
     FactoryGirl.create(:pubfile)
     pubfile2 = FactoryGirl.create(:pubfile, pfile: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', '美丽的sky.jpg')))
     expect(Pubfile.all.size).to eq(2)
     expect(pubfile2.pfile.url).to eq("/uploads/pubfiles/mei-li-de-sky.jpg")
     expect(pubfile2.name).to eq("美丽的sky.jpg")
     expect(pubfile2.description).to eq("it is very beautiful")
  end

  it "should not valid with same file name" do
     FactoryGirl.create(:pubfile)
     expect(Pubfile.new(FactoryGirl.attributes_for(:pubfile))).not_to be_valid
  end

  it "should not valid with out pfile" do
     expect(Pubfile.new(FactoryGirl.attributes_for(:pubfile,pfile: ""))).not_to be_valid
  end

  it "should update ok with right name and url" do
     pubfile1 = FactoryGirl.create(:pubfile)
     pubfile1.update(pfile: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', '美丽的sky.jpg')))
     expect(pubfile1.pfile.url).to eq("/uploads/pubfiles/mei-li-de-sky.jpg")
     expect(pubfile1.name).to eq("美丽的sky.jpg")
     expect(pubfile1.description).to eq("it is very beautiful")
  end
end
