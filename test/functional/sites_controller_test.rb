require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
SitesController.class_eval { def rescue_action(e) raise e end }

class SitesControllerTest < Test::Unit::TestCase
  test_helper :login, :difference
  fixtures :sites
  def setup
    @controller = SitesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as :admin
  end

  def test_should_require_login
    logout
    %w{index new edit}.each do |action|
      get action
      assert_response :redirect
    end
    post :create
    assert_response :redirect
    %w{update move_higher move_lower move_to_top move_to_bottom}.each do |action|
      put action
      assert_response :redirect
    end
    delete :destroy
    assert_response :redirect
  end
  
  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:sites)
  end
  
  def test_new
    get :new
    assert_response :success
    assert_not_nil assigns(:site)
  end
  
  def test_create
    assert_difference Site, :count do
      post :create, :site => {:name => "New site", :domain => "new-site", :position => nil, :base_domain => "new-site.dp.com"}
      assert_response :redirect
      assert_equal "New site", assigns(:site).name
      assert_equal "new-site", assigns(:site).domain
    end
  end
  
  def test_edit
    get :edit, :id => 1
    assert_response :success
    assert_not_nil assigns(:site)
    assert_equal sites(:one), assigns(:site)
  end

  def test_update
    put :update, :id => 1, :site => {:name => "My other site"}
    assert_response :redirect
    sites(:one).reload
    assert_equal "My other site", sites(:one).name
  end
  
  def test_destroy
    assert_difference Site, :count, -1 do
      delete :destroy, :id => 1
      assert_response :redirect
    end
  end
end
