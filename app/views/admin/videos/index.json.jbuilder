json.array!(@videos) do |video|
  json.extract! video, :id, :caption, :address, :slug, :deleted_at
  json.url video_url(video, format: :json)
end
