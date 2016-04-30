class HomeController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.rank(:row_order).latest
  end
  
end
