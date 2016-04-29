class HomeController < ApplicationController
  def index
    @tags = Tag.latest
  end
  
end
