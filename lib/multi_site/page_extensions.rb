module MultiSite::PageExtensions
  def self.included(base)
    base.class_eval {
      alias_method_chain :url, :sites
      mattr_accessor :current_site
      has_one :site, :foreign_key => "homepage_id", :dependent => :nullify
    }
    base.extend ClassMethods
    class << base
      alias_method_chain :find_by_url, :sites
    end
  end
  
  module ClassMethods
    def find_by_url_with_sites(url, live=true)
      root = find_by_parent_id(nil)
      if self.current_site.is_a?(Site)
        root = self.current_site.homepage
      end
      raise Page::MissingRootPageError unless root
      root.find_by_url(url, live)
    end
  end
  
  def url_with_sites
    if parent
      parent.child_url(self)
    else
      "/"
    end
  end
end
