VIDEO_ATTRIBUTES = [:caption, :address, :deleted_at, :slug]
VALID_VIDEO_ATTRIBUTES = [:address]


RSpec.describe Video, type: :model do
  VIDEO_ATTRIBUTES.each do |attr|
    it "has a #{attr}" do
      video = create(:video)
      expect(video).to respond_to(attr)
    end
  end
  
  context "validations" do
    VALID_VIDEO_ATTRIBUTES.each do |attr|
      it "is invalid without a #{attr}" do
        video = build(:video, attr => nil)
        expect(video).to_not be_valid
        expect(video.errors[attr].size).to eq 1
        video[attr] = "A Valid #{attr}"
        expect(video).to be_valid
        expect(video.errors[attr].size).to eq 0
      end
    end
  end
end
