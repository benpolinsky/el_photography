module ApplicationHelper
  def resource
    @resource ||= User.new
  end
  
  def theme_class
    "theme_#{Theme.active.id}" if Theme.active.present?
  end
  
  def quick_row(left_text, right_text)
    capture do
      concat content_tag :p, "#{left_text} #{content_tag(:span, content_tag(:strong, right_text), class: 'text-right')}".html_safe
    end
  end
  
  # from:
  # http://www.terracoding.com/blog/retina-carrierwave-images/
  def retina_image_tag(uploader, version, options={})
    options.symbolize_keys!
    options[:srcset] ||=  (2..3).map do |multiplier|
                            name = "#{version}_#{multiplier}x"
                            if uploader.version_exists?(name) &&
                              source = uploader.url(name).presence
                              "#{source} #{multiplier}x"
                            else
                              nil
                            end
                          end.compact.join(', ')

    image_tag(uploader.url(version), options)
  end
  #https://gist.github.com/henrik/2ddcc6ab8c66e7c49305
  def image_set_tag_3x(source, options = {})
    srcset = [ 2, 3 ].map { |num|
      name = source.sub("_1x.", "_#{num}x.")
      "#{path_to_image(name)} #{num}x"
    }.join(", ")

    image_tag(source, options.merge(srcset: srcset))
  end
end
