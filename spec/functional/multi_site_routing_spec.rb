require File.dirname(__FILE__) + '/../spec_helper'

TestController = Class.new(ApplicationController)

describe TestController, "for MultiSite routing" do
  dataset :sites
  
  before(:all) do
    ActionController::Routing::Routes.clear!
    ActionController::Routing::Routes.draw do |map|
      map.connect '/single', :controller => 'test', :action => "index", :conditions => { :site => 'My Site' }
      map.connect '/multi', :controller =>  'test', :action => "index", :conditions => { :site => ['My Site', 'Your Site'] }
    end
  end

  describe "with single site" do
    it "should recognize routing" do
      {:controller => 'test', :action => 'index'}.should recognize_request("http://mysite.domain.com/single")
    end

    it "should not recognize an undefined route" do
      {:controller => 'test', :action => 'index'}.should_not recognize_request("http://yoursite.domain.com/single")
    end
  end

  describe "with multiple sites" do
    it "should recognize routing" do
      {:controller => 'test', :action => "index"}.should recognize_request("http://mysite.domain.com/multi")
      {:controller => 'test', :action => "index"}.should recognize_request("http://yoursite.domain.com/multi")
    end

    it "should not recognize an undefined route" do
      {:controller => 'test', :action => "index"}.should_not recognize_request("http://digitalpulp.com/multi")
    end
  end

end