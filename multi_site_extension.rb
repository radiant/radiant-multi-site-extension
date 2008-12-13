require_dependency 'application'

class MultiSiteExtension < Radiant::Extension
  version "0.2"
  description %{ Enables virtual sites to be created with associated domain names.
                 Also scopes the sitemap view to any given page (or the root of an
                 individual site). }
  url "http://dev.radiantcms.org/svn/radiant/trunk/extensions/multi_site"

  define_routes do |map|
      map.resources :sites, :path_prefix => "/admin",
                  :member => {
                    :move_higher => :post,
                    :move_lower => :post,
                    :move_to_top => :put,
                    :move_to_bottom => :put
                  }
  end

  def activate
    require 'slugify'
    require_dependency 'application'

    Page.send :include, MultiSite::PageExtensions
    SiteController.send :include, MultiSite::SiteControllerExtensions
    Admin::PagesController.send :include, MultiSite::PagesControllerExtensions
    ResponseCache.send :include, MultiSite::ResponseCacheExtensions
    Radiant::Config["dev.host"] = 'preview'
    # Add site navigation
    admin.page.index.add :top, "site_subnav"
    admin.tabs.add "Sites", "/admin/sites", :visibility => [:admin]
  end

  def deactivate
    admin.tabs.remove "Sites"
  end

end
