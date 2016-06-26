class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:coming_soon]
  
  def coming_soon
    render(layout: 'devise')
  end
  
  def email_sign_up
  end
  
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
    @contact_page = BpCustomFields::AbstractResource.find_by(name: "contact")
    @title = @contact_page.find_fields("Contact Page Title").first
    @text = @contact_page.find_fields("Contact Page Text").first
  end
  
  def about
    if @page_template = PageTemplate.find_by(page: "about")
      template = Liquid::Template.parse(@page_template.body)
      @liquid_template = template.render
    else
      @about_page = BpCustomFields::AbstractResource.find_by(name: "about")
      @title = @about_page.find_fields("About Page Title").first
      @text = @about_page.find_fields("About Page Text").first
    end
  end
  
  def send_message
    if ContactMailer.contact_elliot(message_params[:email], message_params[:name], message_params[:message]).deliver_later
      redirect_to root_path
    else
      render :contact
    end  
  end
  
  
  
  private
  
  def message_params
    params.permit(:email, :name, :message)
  end
  
end
# 