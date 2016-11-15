crumb :root do
  link "Home", root_path
end

crumb :tags do
  link "All Tags", tags_path
end

crumb :tag do |tag|
  link tag.name, tag_path(tag)
end

crumb :photos do
  link "All Photos", photos_path
end

crumb :photo do
  link photo.caption, photo_path(photo)
end

# Admin
crumb :admin_home do
  link "Dashboard", admin_root_path
end

crumb :orders do
  link "All Orders", admin_orders_path
  parent :admin_home
end

crumb :order do |order|
  link "Order #{order.short_or_uid}", admin_order_path(order)
  parent :orders
end

crumb :admin_videos do
  link "All Videos", admin_videos_path
  parent :admin_home
end

crumb :admin_video do |video|
  unless video.new_record?
    link video.video_id, admin_video_path(video)
  else
    link "New Video", new_admin_video_path
  end
  parent :admin_videos
end

crumb :reorder_admin_videos do
  link "Reorder Videos", reorder_admin_videos_path
  parent :admin_videos
end

crumb :admin_photos do
  link "All Photos", admin_photos_path
  parent :admin_home
end

crumb :reorder_admin_photos do
  link "Reorder Photos", reorder_admin_photos_path
  parent :admin_photos
end

crumb :admin_photo do |photo|
  unless photo.new_record?
    link (photo.caption ? photo.caption : photo.id), admin_photo_path(photo)
  else
    link "New Photo", new_admin_photo_path
  end
  parent :admin_photos
end


crumb :admin_products do
  link "All Products", admin_products_path
  parent :admin_home
end

crumb :admin_product do |product|
  unless product.new_record?
    link product.name, admin_product_path(product)
  else
    link "New Product", new_admin_product_path
  end
  parent :admin_products
end

crumb :admin_tags do
  link "All Tags", admin_tags_path
  parent :admin_home
end


crumb :admin_tag do |tag|
  unless tag.new_record?
    link tag.name, admin_tag_path(tag)
  else
    link "New Tag", new_admin_tag_path(tag)
  end
  parent :admin_tags
end


crumb :admin_themes do
  link "All Themes", admin_themes_path
  parent :admin_home
end


crumb :admin_theme do |theme|
  unless theme.new_record?
    link "Theme ##{theme.id}", admin_theme_path(theme)
  else
    link "New Theme", new_admin_theme_path
  end
  parent :admin_themes
end





# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).