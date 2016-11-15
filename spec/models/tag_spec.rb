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
  
  context "tagging rankings", focus: true do
    let(:yoga_one){create(:photo, caption: "Yoga One")}
    let(:yoga_two){create(:photo, caption: "Yoga Two")}
    let(:yoga_three){create(:photo, caption: "Yoga Three")}
  
    let(:oil_one){create(:photo, caption: "Oil One")}
    let(:oil_two){create(:photo, caption: "Oil Two")}
    let(:oil_three){create(:photo, caption: "Oil Three")}
    
    it "each tagged model has an independent ranking by tag" do

      [yoga_one, yoga_two, yoga_three].each do |photo|
        photo.tag_list.add('yoga')
        photo.save
      end
      
      [oil_one, oil_two, oil_three].each do |photo|
        oil_tag = photo.tag_list.add('oil')
        photo.save
      end
      
      oil_tag = Tag.all.find_by(name: "oil")
      yoga_tag = Tag.all.find_by(name: "yoga")

      oil_one_tagging = oil_one.taggings.find_by(tag_id: oil_tag.id) 
      oil_one_tagging.update(row_order_position: 2)
      expect(ActsAsTaggableOn::Tagging.where(tag_id: oil_tag).rank(:row_order).last).to eq oil_one_tagging
      
      oil_two_tagging = oil_two.taggings.find_by(tag_id: oil_tag.id) 
      oil_two_tagging.update(row_order_position: 1)
      expect(ActsAsTaggableOn::Tagging.where(tag_id: oil_tag).rank(:row_order).last).to eq oil_one_tagging
            
      oil_three_tagging = oil_three.taggings.find_by(tag_id: oil_tag.id) 
      oil_three_tagging.update(row_order_position: 2)
      expect(ActsAsTaggableOn::Tagging.where(tag_id: oil_tag).rank(:row_order).last).to eq oil_three_tagging
      
      ranked_taggings = ActsAsTaggableOn::Tagging.where(tag_id: oil_tag).rank(:row_order)
      expect(ranked_taggings).to match [oil_two_tagging, oil_one_tagging, oil_three_tagging]
    end
  end
  
end