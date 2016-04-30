class Admin::PreviewController < AdminController
  def index
    @tags = Tag.latest
    @theme = Theme.find(params[:theme_id]) if params[:theme_id]
  end
end