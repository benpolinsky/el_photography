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
    
  end
  
  def send_message
    byebug
    if ContactMailer.contact_elliot(params).deliver_now
      redirect_to root_path
    else
      render :contact
    end  
  end
  
  def about
  end
  
  
  private
  
  def message_params
  end
  
end
