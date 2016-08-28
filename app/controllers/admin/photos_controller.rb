class Admin::PhotosController < AdminController
  before_action :set_photo, only: [:show, :edit, :destroy]

  def index
    @q = Photo.not_variants.ransack(params[:q])
    @photos = @q.result.rank(:row_order).page(params[:page])
  end

  def show
    if request.url != url_for([:admin, @photo])
     return redirect_to [:admin, @photo], :status => :moved_permanently
    end
  end

  def new
    @photo = Photo.new
  end


  def edit
    if request.path != edit_admin_photo_path(@photo)
     return redirect_to [:edit, :admin, @photo], :status => :moved_permanently
    end
  end


  def create
    @photo = Photo.new(photo_params)
    # Evidently, this is the best solution
    # I've come up with w/r/t tags being created twice quickly...?
    times ||= 3
    begin
      @photo.save
    rescue
      if times > 0
        times -= 1
        retry
      end
    end
    
    respond_to do |format|
      if @photo.save
        format.html { redirect_to [:admin, @photo], notice: 'Photo was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @photo] }
      else
        @resource = @photo
        format.html { render :new }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @photo = Photo.friendly.find(params[:id])
    respond_to do |format|
      if params[:photo] && @photo.update_attributes(photo_params)
        format.html { redirect_to [:admin, :photos], notice: 'Photo was successfully updated.' }
        format.json {head :no_content}
        format.js
      else
        @resource = @photo
        @errors = error_list_for(@photo)
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end


  def destroy
    if @photo.photoable.present?
      redirect_to admin_photos_url, notice: "Sorry, this photo is attached to a product.  Delete that first!"
    else
      @photo.destroy
      respond_to do |format|
        format.html { redirect_to admin_photos_url, notice: 'Photo was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end
  
  def reorder
    @photos = Photo.all.rank(:row_order)
  end
  
  def update_row_order
    @photo = Photo.find(params[:item][:item_id])
    @photo.row_order_position = params[:item][:row_order_position]
    @photo.save
    head :created
  end
  
  private
  def set_photo
    @photo = Photo.friendly.find(params[:id])
  end
  

  def photo_params
    params.require(:photo).permit(:caption, :id, :image, :temporary_slug, :deleted_at, :tag_list, :tag_list => [])
  end
end
