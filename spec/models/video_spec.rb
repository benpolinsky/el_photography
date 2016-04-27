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
  
  context "addresses and ids" do
    before do
      @video = build(:video)
    end
    
    it "can convert a vimeo url to its id without www" do
      @video.address = "https://vimeo.com/87110435"
      expect(@video.video_id).to eq "87110435"
    end
    
    it "can convert a vimeo url to its id with www" do
      @video.address = "https://www.vimeo.com/87110435"
      expect(@video.video_id).to eq "87110435"
    end
    
    it "can convert a vimeo url to its id with https" do
      @video.address = "https://vimeo.com/87110435"
      expect(@video.video_id).to eq "87110435"
    end
    
    it "can convert a vimeo url to its id without https" do
      @video.address = "http://www.vimeo.com/87110435"
      expect(@video.video_id).to eq "87110435"
    end
    
    it "can convert a youtube url to its id without www" do
      @video.address = "https://youtube.com/watch?v=XQu8TTBmGhA"
      expect(@video.video_id).to eq "XQu8TTBmGhA"
    end
    
    it "can convert a youtube url to its id with www" do
      @video.address = "https://www.youtube.com/watch?v=XQu8TTBmGhA"
      expect(@video.video_id).to eq "XQu8TTBmGhA"
    end
    
    it "can convert a youtube url to its id with https" do
      @video.address = "https://www.youtube.com/watch?v=XQu8TTBmGhA"
      expect(@video.video_id).to eq "XQu8TTBmGhA"
    end
    
    it "can convert a youtube url to its id without https" do
      @video.address = "https://www.youtube.com/watch?v=XQu8TTBmGhA"
      expect(@video.video_id).to eq "XQu8TTBmGhA"
    end
  end
end
