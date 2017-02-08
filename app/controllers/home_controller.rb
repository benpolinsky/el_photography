class HomeController < ApplicationController
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
    set_request_variant
    @tag = ActsAsTaggableOn::Tag.friendly.find(params[:id])
    @taggings = ActsAsTaggableOn::Tagging.where(tag_id: @tag.id).rank(:row_order)
  end
  
  def contact
    if @page_template = PageTemplate.find_by(page: "contact")
      setup_liquid
    else
      @contact_page = BpCustomFields::AbstractResource.find_by(name: "contact")
      @title = @contact_page.find_fields("Contact Page Title").first
      @text = @contact_page.find_fields("Contact Page Text").first
    end
  end
  
  def send_message
    if ContactMailer.contact_elliot(message_params[:email], message_params[:name], message_params[:message]).deliver_now
      redirect_to root_path, notice: "Thanks, your message is off!"
    else
      render :contact
    end  
  end
  
  def about
    @about_page = BpCustomFields::AbstractResource.find_by(name: "about")
    @title = @about_page.find_fields("About Page Title").first
    @text = @about_page.find_fields("About Page Text").first
    @image = @about_page.find_fields("About Image").first
  end
  


  
  
  
  private
  def set_request_variant
    request.variant = :mobile if (browser.device.mobile? || browser.device.tablet?)
  end
   
  def message_params
    params.permit(:email, :name, :message)
  end
  
  def setup_liquid
    template = Liquid::Template.parse(@page_template.body)
    setup_custom_fields(@page_template.page.try(:downcase))
    @user_template = template.render(available_drops, registers: {request: request, current_abstract_resource: @page })
    @css_theme = Theme.active
  end
  
  def setup_custom_fields(name)
    @page = BpCustomFields::AbstractResource.find_by(name: name)
    if @page
      @group = @page.groups.first
      @group_drop = BpCustomFields::GroupDrop.new(@group)
    end
  end
  
  def available_drops
    {
      'group' => @group_drop,
      'products' => ProductsDrop.new(Product.all),
      'product' => Product.first,
      'cart' => @cart,
      'tags' => ActsAsTaggableOn::TagsDrop.new(ActsAsTaggableOn::Tag.all)
    }
  end
  
end
# 