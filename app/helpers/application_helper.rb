module ApplicationHelper
  def theme_class
    "theme_#{Theme.active.id}" if Theme.active.present?
  end
end
