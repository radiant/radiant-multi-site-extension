require File.dirname(__FILE__) + '/../spec_helper'

describe ResponseCache do
  dataset :sites
  
  before do
    @cache = ResponseCache.new
  end
  
  it "should scope cache location to current site" do
    Page.current_site = nil
    @cache.send(:page_cache_path_without_site, '/').should eql(@cache.send(:page_cache_path, "/"))
    @cache.send(:page_cache_path_without_site, '/blah').should eql(@cache.send(:page_cache_path, "/blah"))
    
    Page.current_site = sites(:mysite)
    base_path = File.expand_path(File.join(@cache.directory, sites(:mysite).base_domain))
    @cache.send(:page_cache_path, "/").should eql(File.join(base_path, '_site-root'))
    @cache.send(:page_cache_path_without_site, '/mysite.domain.com/blah').should eql(File.join(base_path, 'blah'))
  end
  
end