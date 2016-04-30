class Admin::ThemesController < AdminController
  def index
    @themes = Theme.order(created_at: :desc)
  end
  
  def new
    @theme = Theme.new
  end
  
  def create
    @theme = Theme.new(theme_params)
    if @theme.save
      redirect_to [:admin, :themes]
    else
      render :new, notice: "Sorry!  Forgive-a-ness please"
    end
  end
  
  def show
    
  end
  
  def edit
    @theme = Theme.find(params[:id])
  end
  
  def update
    @theme = Theme.find(params[:id])
    if @theme.update_attributes(theme_params)
      @theme.compile if @theme.active?
      redirect_to [:admin, :themes]
    else
      render :new, notice: "Sorry!  Forgive-a-ness please"
    end
  end
  
  def destroy
  end
  
  def preview
    # find theme and compile style 
    # redirect to preview with that style
  end
  
  def activate
    @theme = Theme.find(params[:id])
    if @theme.inactive?
      themes = Theme.all.except(@theme)
      themes.update_all(active: false) if themes.any?
      @theme.compile
      @theme.activate!
    end
    redirect_to [:admin, :themes]
  end
  
  def deactivate
    @theme = Theme.find(params[:id])
    @theme.deactivate! if @theme.active?
    redirect_to [:admin, :themes]
  end
  
  private
  
  def theme_params
    params.require(:theme).permit(:css, :active)
  end
end