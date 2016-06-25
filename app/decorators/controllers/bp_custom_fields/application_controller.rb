BpCustomFields::ApplicationController.class_eval do
  before_action :authenticate_user!
  before_action :set_nav_names
  
  def set_nav_names
    @nav_names ||= ["Photos", "Videos", "Tags", "Products", "Orders", "Users"]
    @abstract_resource_names ||= BpCustomFields::AbstractResource.where("name = ? OR name = ?", 'about', 'contact')
  end
end