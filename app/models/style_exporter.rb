# Thanks in large part to:
# http://blog.diatomenterprises.com/custom-stylesheets-dynamically-with-rails-and-sass/
class StyleExporter
  attr_reader :custom_style, :body, :env, :filename, :scss_file

  def initialize(theme_id)
    @custom_style = Theme.find(theme_id)
    @filename = "esp_custom_#{theme_id}_#{custom_style.updated_at.to_i}"
    @scss_file = File.new(scss_file_path, 'w')
    @body = @custom_style.css
    @env = Rails.application.assets
  end
  
  def compile
    begin
      scss_file.write body
      #scss_file.write generate_css
      scss_file.flush
      FileUtils.cp scss_file, Rails.root.join("public", "stylesheets")
      @custom_style.update(css_file: filename)
    ensure
      scss_file.close
      FileUtils.remove_file(scss_file_path)
    end
  end
  
  
  def generate_css
    Sass::Engine.new(asset_source, {
      syntax: :scss,
      cache: false,
      read_cache: false,
      style: :compressed
    }).render
  end
  
  def asset_source
    if env.find_asset(filename)
      env.find_asset(filename).source
    else
      uri = Sprockets::URIUtils.build_asset_uri(scss_file.path, type: "text/css")
      asset = Sprockets::UnloadedAsset.new(uri, env)
      env.load(asset.uri).source
    end
  end
  
    
  def scss_file_path
    @scss_file_path ||= File.join(scss_tmpfile_path, "#{filename}.css")
  end
  
  def scss_tmpfile_path
    @scss_file_path ||= File.join(Rails.root, 'tmp', 'generate_css')
    FileUtils.mkdir_p(@scss_file_path) unless File.exists?(@scss_file_path)
    @scss_file_path
  end
  
end