module MultiSite::SiteControllerExtensions
  def self.included(base)
    base.class_eval do
      before_filter :set_site
    end
  end
  
  def set_site
    Page.current_site = Site.find_for_host(request.host)
    true
  end
end