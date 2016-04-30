ActsAsTaggableOn::Tag.class_eval do
  include RankedModel
  ranks :row_order
  
  def self.latest
    all.includes(:taggings).order("taggings.created_at ASC")
  end
end
