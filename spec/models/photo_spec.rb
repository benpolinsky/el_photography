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
        photo = build(:photo, attr => nil)
        expect(photo).to_not be_valid
        expect(photo.errors[attr].size).to eq 1
        photo[attr] = "A Valid #{attr}"
        expect(photo).to be_valid
        expect(photo.errors[attr].size).to eq 0
      end
    end
  end
end
