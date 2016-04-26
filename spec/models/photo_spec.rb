require 'rails_helper'

PHOTO_ATTRIBUTES = [:caption, :image, :deleted_at, :slug]
VALID_PHOTO_ATTRIBUTES = [:image]


RSpec.describe Photo, type: :model do
  PHOTO_ATTRIBUTES.each do |attr|
    it "has a #{attr}" do
      photo = create(:photo)
      expect(photo).to respond_to(attr)
    end
  end
  
  context "validations" do
    VALID_PHOTO_ATTRIBUTES.each do |attr|
      it "is invalid without a #{attr}" do
        photo = create(:photo)
        expect(photo).to be_valid
        saved_attr = photo[attr]
        if attr == :image
          photo.remove_image!
          photo.save
        else 
          photo[attr] = nil
        end
        expect(photo).to_not be_valid
        expect(photo.errors[attr].size).to eq 1
        
        if attr == :image
          photo.image = File.open("#{Rails.root}/spec/support/files/fake_image.png")
        else
          photo[attr] = saved_attr
        end
        expect(photo).to be_valid
        expect(photo.errors[attr].size).to eq 0
      end
    end
  end
end
