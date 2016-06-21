# A Drop seems like a slightly souped up view model.  
# It allows you to blacklist and whitelist which methods are invokable

class PageDrop < Liquid::Drop
  include ActionView::Helpers::AssetTagHelper
  attr_reader :page
  
  def initialize(page_name)
    @page = BpCustomFields::AbstractResource.find_by(name: page_name)
  end
  
  def custom_fields
    page.custom_fields
  end
  
  def groups_and_fields
    page.groups_and_fields
  end

end