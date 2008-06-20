require File.dirname(__FILE__) + '/../test_helper'

class SiteTest < Test::Unit::TestCase
  fixtures :sites, :pages
  test_helper :difference
  
  def setup
    @site = Site.new :name => "Test Site", :domain => "test", :homepage_id => 1, :base_domain => "test.host"
  end
  
  def test_should_require_a_name
    @site.name = nil
    assert !@site.valid?
    assert_not_nil @site.errors.on(:name)
  end
  
  def test_should_require_unique_domain
    @site.domain = sites(:one).domain
    assert !@site.valid?
    assert_not_nil @site.errors.on(:domain)
  end
  
  def test_should_have_an_associated_homepage
    assert_respond_to @site, :homepage
    assert_equal pages(:homepage), sites(:one).homepage
  end
  
  def test_should_create_a_homepage_after_creation
    @site.homepage_id = nil
    assert @site.save
    assert_not_nil @site.homepage
    assert_valid @site.homepage
    @site.homepage.parts.each {|part| assert_valid part }
    assert !@site.homepage.new_record?
  end
  
  def test_should_find_an_appropriate_site_for_a_given_hostname
    assert_equal sites(:one), Site.find_for_host("mysite.domain.com")
    assert_equal sites(:two), Site.find_for_host("yoursite.com")
    assert_equal sites(:two), Site.find_for_host("yoursite.unknown.com")
    assert_equal sites(:three), Site.find_for_host("unknown.com")
    assert_equal sites(:subdomain), Site.find_for_host("sub.unknown.com")
    assert_equal sites(:subdomain), Site.find_for_host("sub.domain.com")
  end
  
  def test_should_generate_url_for_site_from_path
    assert_equal "http://mysite.domain.com/", sites(:one).url
    assert_equal "http://mysite.domain.com/about", sites(:one).url("/about")
  end
  
  def test_should_generate_dev_url_for_site_from_path
    assert_equal "http://preview.mysite.domain.com/", sites(:one).dev_url
    assert_equal "http://preview.mysite.domain.com/about", sites(:one).dev_url("/about")
  end
  
  def test_should_require_base_domain
    @site.base_domain = nil
    assert !@site.valid?
    assert_not_nil @site.errors.on(:base_domain)
  end
end
