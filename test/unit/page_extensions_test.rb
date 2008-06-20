require File.dirname(__FILE__) + '/../test_helper'

class PageExtensionsTest < Test::Unit::TestCase
  fixtures :pages, :sites
  test_helper :page
  
  def setup
    @page = pages(:homepage)
  end

  def test_should_override_url
    assert_respond_to @page, :url_with_sites
    assert_respond_to @page, :url_without_sites
    assert_equal "/", @page.url
    @page.slug = "some-slug"
    assert_equal "/", @page.url
  end
  
  def test_should_override_class_find_by_url
    assert_respond_to Page, :find_by_url_with_sites
    assert_respond_to Page, :find_by_url_without_sites
    assert_respond_to Page, :current_site
    assert_respond_to Page, :current_site=
    # Defaults should still work
    assert_nothing_raised {
      Page.current_site = nil
      assert_equal pages(:homepage), Page.find_by_url("/")
    }
    # Now find a site-scoped page
    assert_nothing_raised {
      Page.current_site = sites(:one)
      assert_equal pages(:homepage), Page.find_by_url("/")
      assert_equal pages(:documentation), Page.find_by_url("/documentation")
    }
    # Now try a site that has no homepage
    assert_raises(Page::MissingRootPageError) {
      Page.current_site = sites(:two)
      Page.find_by_url("/")
    }
  end
  
  def test_should_nullify_site_homepage_id_on_destroy
    assert_not_nil sites(:one).homepage_id
    pages(:homepage).destroy
    assert_nil sites(:one).reload.homepage_id
  end
end
