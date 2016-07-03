class GetCustomField < Liquid::Tag
  def initialize(tag_name, field_name, tokens)
    super
    @field_name = field_name
  end
  
  def render(context)
    byebug
    BpCustomFields.find_field(@field_name.gsub('"', '').strip, context.registers[:current_abstract_resource]).display
  end
end

Liquid::Template.register_tag('get_custom_field', GetCustomField)