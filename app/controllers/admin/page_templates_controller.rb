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
      redirect_to [:admin, :page_templates]
    else
      render :live
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
  
  
  def live
    template = Liquid::Template.parse(@page_template.body)
    setup_custom_fields(@page_template.title.try(:downcase))
    @user_template = template.render({'group' => @group_drop})
  end
  
  def live_render
    template = Liquid::Template.parse(@page_template.body)
    setup_custom_fields(@page_template.title.try(:downcase))
    @user_template = template.render({'group' => @group_drop})
    render layout: 'preview'
  end
  
  def live_update
    if @page_template.update_attributes(page_template_params)
      template = Liquid::Template.parse(@page_template.body)
      setup_custom_fields(@page_template.title.try(:downcase))
      @user_template = template.render({'group' => @group_drop})
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
    @page_template = if params[:id]
      PageTemplate.find(params[:id])
    else
      PageTemplate.create
    end
  end
  
  def page_template_params
    params.require(:page_template).permit(:title, :body, :active, :slug, :page)
  end
end