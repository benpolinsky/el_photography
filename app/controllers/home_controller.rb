class HomeController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.rank(:row_order).latest
    # PageTemplatesChannel.broadcast_to(
 #    current_user,
 #    title: "The Products Page",
 #    body: "Some code would go here."
 #    )
  end
  
  def tag
    @tag = ActsAsTaggableOn::Tag.friendly.find(params[:id])
    @assets = Tag.assets_for_tag(@tag)
  end
  
  def contact
    @liquid_template = PageTemplate.find_by(title: "about-page-template")
    @contact_page = BpCustomFields::AbstractResource.find_by(name: "contact")
    @title = @contact_page.find_fields("Contact Page Title").first
    @text = @contact_page.find_fields("Contact Page Text").first
  end
  
  def about
    @about_page = BpCustomFields::AbstractResource.find_by(name: "about")

    @title = @about_page.find_fields("About Page Title").first
    @text = @about_page.find_fields("About Page Text").first
  end
  
  def send_message
    if ContactMailer.contact_elliot(params).deliver_now
      redirect_to root_path
    else
      render :contact
    end  
  end
  
  
  
  private
  
  def message_params
  end
  
end
# 