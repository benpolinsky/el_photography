class Admin::PageTemplatesController < AdminController
  before_filter :find_page_template, except: [:index, :create, :new]
  
  
  def index
    @page_templates = PageTemplate.all
  end
  
  def new
    @page_template = PageTemplate.create
    redirect_to [:live, :admin, @page_template]
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
      redirect_to [:admin, :page_templates]
    else
      render :live
    end
  end
  
  
  def create
    @page_template = PageTemplate.new(page_template_params)
    if @page_template.save
      redirect_to [:admin, @page_template, :live]
    else
      render :new
    end
  end
  
  def destroy
    @page_template.destroy
    redirect_to [:admin, :page_templates]
  end
  
  # container for code and live-reload-frame
  def live
    setup_liquid
  end
  
  # processes new code
  def live_render
    setup_liquid
    render layout: 'preview'
  end
  
  # 'triggers' webhook connection to live-reload
  def live_update
    if @page_template.update_attributes(page_template_params)
      @css_theme = Theme.active
      if css_params[:body]
        @css_theme.update_attribute('css', css_params[:body])
        @css_theme.compile # this has gotta be overkill.....
      end
      @products_remaining = @cart.number_of_products_inside(Product.first.id)
      template = Liquid::Template.parse(@page_template.body)
      setup_custom_fields(@page_template.title.try(:downcase))
      @user_template = template.render(available_drops, registers: {request: request})

      ActionCable.server.broadcast 'page_templates',
      page_template: @page_template.id,
      page_template_code: @user_template,
      css_template: @css_theme.try(:id),
      css_template_code: @css_theme.try(:css)
    end
    head :ok
  end

  private
  
  def setup_liquid
    template = Liquid::Template.parse(@page_template.body)
    setup_custom_fields(@page_template.title.try(:downcase))
    @user_template = template.render(available_drops, registers: {request: request})
    @css_theme = Theme.active
    @products_remaining = @cart.number_of_products_inside(Product.first.id)
  end
  
  def setup_custom_fields(name)
    page = BpCustomFields::AbstractResource.find_by(name: name)
    if page
      @group = page.groups.first
      @group_drop = BpCustomFields::GroupDrop.new(group)
    end
  end
  
  def find_page_template
    @page_template = PageTemplate.find(params[:id])
  end
  
  def page_template_params
    params.require(:page_template).permit(:title, :body, :active, :slug, :page)
  end
  
  def css_params
    params.require(:css_template).permit(:body)
  end
  
  # obviously, you don't want to load all drops for all templates
  # this may work initially, but you're going to want find a good way to handle this
  def available_drops
    {
      'group' => @group_drop,
      'products' => ProductsDrop.new(Product.all),
      'product' => Product.first,
      'cart' => @cart,
      'tags' => ActsAsTaggableOn::TagsDrop.new(ActsAsTaggableOn::Tag.all)
    }
  end
end