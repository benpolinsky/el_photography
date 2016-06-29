class Admin::PhotosController < AdminController
  before_action :set_photo, only: [:show, :edit, :destroy]
  respond_to :html, :js

  # GET /photos
  # GET /photos.json
  def index
    @q = Photo.ransack(params[:q])
    @photos = @q.result.rank(:row_order).page(params[:page])
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    if request.url != url_for([:admin, @photo])
     return redirect_to [:admin, @photo], :status => :moved_permanently
    end
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
    if request.path != edit_admin_photo_path(@photo)
     return redirect_to [:edit, :admin, @photo], :status => :moved_permanently
    end
  end

  # POST /photos
  # POST /photos.json
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

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    @photo = Photo.friendly.find(params[:id])
    respond_to do |format|
      if params[:photo] && @photo.update_attributes(photo_params)
        format.html { redirect_to [:admin, @photo], notice: 'Photo was successfully updated.' }
        format.json {head :created}
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

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to admin_photos_url, notice: 'Photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def update_row_order
    @photo = Photo.find(params[:item][:item_id])
    @photo.row_order_position = params[:item][:row_order_position]
    @photo.save
    head :created
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.friendly.find(params[:id])
    end
    

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:caption, :image, :temporary_slug, :deleted_at, :tag_list => [])
    end
end
