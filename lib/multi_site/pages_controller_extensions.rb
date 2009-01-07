module MultiSite::PagesControllerExtensions
  def self.included(base)
    base.class_eval {
      alias_method_chain :index, :root
      alias_method_chain :continue_url, :site
      alias_method_chain :remove, :back
      responses.destroy.default do 
        return_url = session[:came_from]
        session[:came_from] = nil
        redirect_to return_url || admin_pages_url(:root => model.root.id)
      end
    }
  end

  def index_with_root
    if params[:root] # If a root page is specified
      @homepage = Page.find(params[:root])
      @site = @homepage.root.site
    elsif @site = Site.first(:order => "position ASC") # If there is a site defined
      if @site.homepage
        @homepage = @site.homepage
      end
    end
    @homepage ||= Page.find_by_parent_id(nil)
    response_for :plural
  end

  def remove_with_back
    session[:came_from] = request.env["HTTP_REFERER"]
    super
  end
  
  def continue_url_with_site(options={})
    options[:redirect_to] || (params[:continue] ? edit_admin_page_url(model) : admin_pages_url(:root => model.root.id))
  end
end
