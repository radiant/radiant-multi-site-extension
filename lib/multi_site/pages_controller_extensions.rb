module MultiSite::PagesControllerExtensions
  def self.included(base)
    base.class_eval do
      alias_method_chain :index, :root
      alias_method_chain :continue_url, :site
      alias_method_chain :remove, :back
      responses.destroy.default do 
        return_url = session[:came_from]
        session[:came_from] = nil
        redirect_to return_url || admin_pages_url(:root => model.root.id)
      end
    end
  end

  def index_with_root
    root_id = params[:root] || session[:last_active_root]
    if @homepage = Page.find_by_id(root_id)
      @site = @homepage.root.site
      session[:last_active_root] = @homepage.id
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
    remove_without_back
  end
  
  def continue_url_with_site(options={})
    options[:redirect_to] || (params[:continue] ? edit_admin_page_url(model) : admin_pages_url(:root => model.root.id))
  end

end
