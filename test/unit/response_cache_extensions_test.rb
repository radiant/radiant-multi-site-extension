require File.dirname(__FILE__) + '/../test_helper'

class ResponseCacheExtensionsTest < Test::Unit::TestCase
  fixtures :sites
  
  def setup
    @cache = ResponseCache.new
  end
  
  def test_should_scope_cache_location_to_current_site
    Page.current_site = nil
    assert_equal @cache.send(:page_cache_path, "/"), @cache.send(:page_cache_path_without_site, '/')
    assert_equal @cache.send(:page_cache_path, "/blah"), @cache.send(:page_cache_path_without_site, '/blah')
    
    Page.current_site = sites(:one)
    base_path = File.expand_path(File.join(@cache.directory, sites(:one).base_domain))
    assert_equal File.join(base_path, '_site-root'), @cache.send(:page_cache_path, "/")
    assert_equal File.join(base_path, 'blah'), @cache.send(:page_cache_path_without_site, '/mysite.domain.com/blah')
  end
end