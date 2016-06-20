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
    template = Liquid::Template.parse(@page_template.body)
    setup_custom_fields(@page_template.title.try(:downcase))
    @user_template = template.render(available_drops)
  end
  
  # processes new code
  def live_render
    template = Liquid::Template.parse(@page_template.body)
    setup_custom_fields(@page_template.title.try(:downcase))
    @user_template = template.render(available_drops)
    render layout: 'preview'
  end
  
  # 'triggers' webhook connection to live-reload
  def live_update
    if @page_template.update_attributes(page_template_params)
      template = Liquid::Template.parse(@page_template.body)
      setup_custom_fields(@page_template.title.try(:downcase))
      @user_template = template.render(available_drops)
      ActionCable.server.broadcast 'page_templates',
      page_template: @page_template.id,
      page_template_code: @user_template
    end
    head :ok
  end

  private
  
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
  
  # obviously, you don't want to load all drops for all templates
  # this may work initially, but you're going to want find a good way to handle this
  def available_drops
    {
      'group' => @group_drop,
      'products' => ProductsDrop.new(Product.all)
    }
  end
end