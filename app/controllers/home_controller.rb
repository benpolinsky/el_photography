class HomeController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.rank(:row_order).latest
    # PageTemplatesChannel.broadcast_to(
 #    current_user,
 #    title: "The Products Page",
 #    body: "Some code would go here."
 #    )
  end
  
end
