module ApplicationHelper
  def theme_class
    "theme_#{Theme.active.id}" if Theme.active.present?
  end
  
  def quick_row(left_text, right_text)
    capture do
      concat content_tag :p, "#{left_text} #{content_tag(:span, content_tag(:strong, right_text), class: 'text-right pull-right')}".html_safe
    end
  end
end
