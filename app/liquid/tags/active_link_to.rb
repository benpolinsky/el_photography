class ActiveLinkToTag < Liquid::Tag
  include ActionView::Helpers::UrlHelper
  include ActiveLinkTo
  def initialize(tag_name, markup, tokens)
    super
    @markup = markup
    @attributes = {}
    markup.scan(Liquid::TagAttributes) do |key, value|
      @attributes[key] = value
    end 
  end
  
  def render(context)
    @registers = context.registers
    active_link_to @attributes['name'], @attributes['link'], @attributes.except(['name', 'link'])
  end
  
  
  private
  #
  # def request
  #   @registers[:request]
  # end
end

Liquid::Template.register_tag('active_link_to', ActiveLinkToTag)