module PhotosHelper
  def dropzone_classes
    request.filtered_parameters["action"] == "new" ? "dropzone" : ""
  end
  
  def tag_selected?(model, tag)
    model.tags.include?(tag) ? tag.name : nil
  end
end
