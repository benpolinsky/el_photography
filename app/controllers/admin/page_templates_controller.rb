class Admin::PageTemplatesController < AdminController
  before_filter :find_page_template
  
  
  def index
    @page_templates = PageTemplate.all
  end
  
  def new
    @page_template = PageTemplate.new
  end
  
  def edit
  end
  
  def show
    template = Liquid::Template.parse(@page_template.body)
    product_drop = ProductDrop.new(Product.first)
    @user_template = template.render({"product" => product_drop})
  end
  
  def update
    if @page_template.update_attributes(page_template_params)
      redirect_to [:admin, @page_template]
    else
      render :edit
    end
  end
  
  def create
    @page_template = PageTemplate.new(page_template_params)
    if @page_template.save
      redirect_to [:admin, @page_template]
    else
      render :new
    end
  end
  
  def destroy
    @page_template.destroy
    redirect_to [:admin, :page_templates]
  end
  

  private
  def find_page_template
    @page_template = PageTemplate.find(params[:id]) if params[:id]
  end
  
  def page_template_params
    params.require(:page_template).permit(:title, :body, :active, :slug)
  end
end