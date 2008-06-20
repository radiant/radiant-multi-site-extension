require File.dirname(__FILE__) + '/../test_helper'

class MultiSiteExtensionTest < Test::Unit::TestCase
   
  def test_initialization
    assert_equal File.join(File.expand_path(RAILS_ROOT), 'vendor', 'extensions', 'multi_site'), MultiSiteExtension.root
    assert_equal 'Multi Site', MultiSiteExtension.extension_name
  end
  
  def test_module_inclusion
    assert Page.included_modules.include?(MultiSite::PageExtensions)
    assert SiteController.included_modules.include?(MultiSite::SiteControllerExtensions)
    assert Admin::PageController.included_modules.include?(MultiSite::PageControllerExtensions)
    assert ResponseCache.included_modules.include?(MultiSite::ResponseCacheExtensions)
  end
end
