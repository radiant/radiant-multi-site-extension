module MultiSite::SiteControllerExtensions
  def self.included(base)
    base.class_eval do
      before_filter :set_site
      alias_method_chain :dev?, :domain
    end
  end
  
  def set_site
    Page.current_site = Site.find_for_host(request.host)
    true
  end
  
  private
    def dev_with_domain?
      prefix = @config["dev.host"] || "dev"
      request.host =~ %r{^#{prefix}\.}
    end
end
