json.array!(@tags) do |admin_tag|
  json.extract! admin_tag, :id
  json.url admin_tag_url(admin_tag, format: :json)
end
