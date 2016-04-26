class Admin::TagsController < AdminController
  
  def index
    @tags = Tag.all
  end

  
  def show
  end

  
  def new
  
  end

  def edit
  end


  def create
  end

  # PATCH/PUT /admin/tags/1
  # PATCH/PUT /admin/tags/1.json
  def update
  
  end

  # DELETE /admin/tags/1
  # DELETE /admin/tags/1.json
  def destroy
 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_tag
      @tag = Tag.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_tag_params
      params.fetch(:admin_tag, {})
    end
end
