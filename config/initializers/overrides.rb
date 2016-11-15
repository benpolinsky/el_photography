ActsAsTaggableOn::Tag.class_eval do
  include RankedModel
  ranks :row_order
  
  def self.latest
    all.includes(:taggings).order("taggings.created_at ASC")
  end
end


ActsAsTaggableOn::Tagging.class_eval do
  include RankedModel
  ranks :row_order, with_same: :tag_id
end
