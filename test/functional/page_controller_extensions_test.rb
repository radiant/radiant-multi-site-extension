require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
Admin::PageController.class_eval { def rescue_action(e) raise e end }

class PageControllerExtensionsTest < Test::Unit::TestCase
  fixtures :sites, :pages
  test_helper :page, :login
  
  def setup
    @controller = Admin::PageController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as(:existing)
  end
  
  def test_should_set_root_to_given_page_id
    get :index, :root => 5
    assert_response :success
    assert_not_nil assigns(:homepage)
    assert_equal 5, assigns(:homepage).id
    assert_equal sites(:one), assigns(:site)
  end
  
  def test_should_pick_first_site_if_no_root_given
    get :index
    assert_response :success
    assert_equal pages(:homepage), assigns(:homepage)
    assert_equal sites(:one), assigns(:site)
  end
  
  def test_should_fallback_on_default_when_no_sites_defined
    Site.delete_all
    get :index
    assert_response :success
    assert_equal pages(:homepage), assigns(:homepage)
  end
  
  def test_should_set_site_when_clearing_cache
    @controller.send :instance_variable_set, "@page", pages(:homepage)
    @controller.send :clear_model_cache
    assert_equal sites(:one), Page.current_site
  end
  
  def test_should_redirect_to_same_site_after_edit
    post :edit, :id => 2
    assert_response :redirect
    assert_redirected_to page_index_url(:root => 1)
  end
end
