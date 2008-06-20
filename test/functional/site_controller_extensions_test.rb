require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
SiteController.class_eval { def rescue_action(e) raise e end }

class SiteControllerExtensionsTest < Test::Unit::TestCase
  fixtures :sites, :pages
  test_helper :page
  
  def setup
    @controller = SiteController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @cache      = @controller.cache
    @cache.perform_caching = false
    @cache.clear
    Page.current_site = nil
  end
  
  def test_should_scope_to_matching_site
    @request.host = "mysite.domain.com"
    get :show_page, :url => ""
    assert_response :success
    assert_equal sites(:one), Page.current_site
    assert_equal pages(:homepage), assigns(:page)
  end
  
  def test_should_use_altered_dev_setting
    @request.host = "mysite.domain.com"
    get :show_page, :url => pages(:homepage_draft).url
    assert_response :not_found

    Radiant::Config.find_by_key("dev.host").destroy
    @request.host = "dev.mysite.domain.com"
    get :show_page, :url => pages(:homepage_draft).url
    assert_response :success
    
    Radiant::Config["dev.host"] = "preview"
    @request.host = "preview.mysite.domain.com"
    get :show_page, :url => pages(:homepage_draft).url
    assert_response :success
  end
end
