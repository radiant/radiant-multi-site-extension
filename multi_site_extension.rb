require_dependency 'application_controller'

class MultiSiteExtension < Radiant::Extension
  version "1.0.0"
  description %{ Enables virtual sites to be created with associated domain names.
                 Also scopes the sitemap view to any given page (or the root of an
                 individual site). }
  url "http://radiantcms.org/"

  def activate
    require 'multi_site/route_extensions'
    require 'multi_site/route_set_extensions'
    Page.send :include, MultiSite::PageExtensions
    SiteController.send :include, MultiSite::SiteControllerExtensions
    Admin::PagesController.send :include, MultiSite::PagesControllerExtensions
    admin.pages.index.add :bottom, "site_subnav"
    tab 'Settings' do |tab|
      tab.add_item 'Sites', '/admin/sites'
    end
    load_default_regions
  end

  def deactivate
  end

  def load_default_regions
    Radiant::AdminUI.class_eval { attr_accessor :sites }
    admin.sites = OpenStruct.new.tap do |sites|
      sites.index = Radiant::AdminUI::RegionSet.new do |index|
        index.header.concat %w{name_th match_th base_th modify_th order_th}
        index.row.concat %w{name_td match_td base_td modify_td order_td}
      end
      sites.edit = Radiant::AdminUI::RegionSet.new do |edit|
        edit.main.concat %w{edit_header edit_form}
        edit.form.concat %w{edit_name edit_match edit_base edit_homepage}
        edit.form_bottom.concat %w{edit_buttons}
      end
      sites.new = sites.edit
    end
  end

end
