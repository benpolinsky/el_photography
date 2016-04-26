FactoryGirl.define do
  factory :photo do
   image { File.open("#{Rails.root}/spec/support/files/fake_image.png") } 
  end
end