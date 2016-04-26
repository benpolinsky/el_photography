class Tag
  TAG = ActsAsTaggableOn::Tag

  def self.first
    TAG.first
  end
  
  def self.first_or_initialize(params={})
    TAG.first_or_initialize(params)
  end
  
  def self.all
    TAG.all
  end
  
  def self.plus_one
    all + [Tag.new_tag]
  end
  
  def self.new_tag(params={})
    TAG.new(params)
  end
  
  def create(params={})
    TAG.create(param)
  end

  def self.list
    all.map(&:name).join(", ")
  end
end