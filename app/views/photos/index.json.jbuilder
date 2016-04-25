json.array!(@photos) do |photo|
  json.extract! photo, :id, :caption, :image, :slug, :deleted_at
  json.url photo_url(photo, format: :json)
end
