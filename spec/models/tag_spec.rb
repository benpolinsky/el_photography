require 'rails_helper'

RSpec.describe "Tagging" do 
  
  context "tag resource" do
    it "Tag is a convenience class" do
      tag = Tag.first_or_initialize
      expect(tag).to be_a ActsAsTaggableOn::Tag
    end
  end
  
  context "relations" do
    before do
      @photo = create(:photo)
      @video = create(:video)
    end
  
  
    it "allows tagging of videos and photos" do
      expect(@photo.tags).to eq []
      expect(@video.tags).to eq []
    
      expect{@video.tag_list.add("Add", "some", "tags")}.to change {@video.tag_list.count}.by 3
      expect{@photo.tag_list.add("some", "photo", "tags")}.to change {@photo.tag_list.count}.by 3
    end
  
    it "can share tags between photos and videos" do
      expect(ActsAsTaggableOn::Tag.all.count).to eq 0
      @video.tag_list.add("Add", "some", "tags")
      @video.save
      @photo.tag_list.add("some", "photo", "tags")
      @photo.save
      expect(ActsAsTaggableOn::Tag.all.count).to eq 4
    end
  end
  
end