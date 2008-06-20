module MultiSite::ResponseCacheExtensions
  
  def self.included(base)
    base.alias_method_chain :page_cache_path, :site
  end
  
  def page_cache_path_with_site(path)
    path = (path.empty? || path == "/") ? "/_site-root" : URI.unescape(path)
    path = File.join(Page.current_site.base_domain, path) if Page.current_site
    root_dir = File.expand_path(page_cache_directory)
    cache_path = File.expand_path(File.join(root_dir, path), root_dir)
    cache_path if cache_path.index(root_dir) == 0
  end
end