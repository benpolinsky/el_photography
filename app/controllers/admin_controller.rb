class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :set_nav_names
  layout 'admin'


  def set_nav_names
    @nav_names ||= ["Photos", "Videos", "Tags", "Products", "Orders", "Users"]
    @abstract_resource_names ||= BpCustomFields::AbstractResource.where("name = ? OR name = ?", 'about', 'contact')
  end
end