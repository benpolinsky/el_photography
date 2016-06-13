class PageTemplatesChannel < ApplicationCable::Channel
  def subscribed
    # page_template = PageTemplate.find(params[:id])
    stream_from "page_templates"
  end
end