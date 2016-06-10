class Admin::TagsController < AdminController
  
  def index
    @tags = ActsAsTaggableOn::Tag.rank(:row_order)
  end

  
  def show
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
  end

  
  def new
    @tag = ActsAsTaggableOn::Tag.new
  end

  def edit
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
  end


  def create
    @tag = ActsAsTaggableOn::Tag.new(tag_params)
    if @tag.save
      redirect_to admin_tags_path
    else
      @resource = @tag
      render :new
    end
  end

  # PATCH/PUT /admin/tags/1
  # PATCH/PUT /admin/tags/1.json
  def update
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    if @tag.update_attribtues(tag_params)
      redirect_to admin_tags_path
    else
      @resource = @tag
      render :edit
    end
  end

  # DELETE /admin/tags/1
  # DELETE /admin/tags/1.json
  def destroy
 
  end
  
  def update_row_order
    @tag = ActsAsTaggableOn::Tag.find(params[:item][:item_id])
    @tag.row_order_position = params[:item][:row_order_position]
    @tag.save
    head :created
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_tag
      @tag = Tag.first
    end
    
    def tag_params
      params.require(:acts_as_taggable_on_tag).permit(:name, :id)
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_tag_params
      params.fetch(:admin_tag, {})
    end
end
