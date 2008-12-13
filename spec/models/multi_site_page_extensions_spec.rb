require File.dirname(__FILE__) + '/../spec_helper'

describe Page do
  dataset :sites
  
  before do
    @page = pages(:home)
  end
  
  describe "#url" do
    it "should alias default" do
      @page.should respond_to(:url_with_sites)
      @page.should respond_to(:url_without_sites)
    end
    
    it "should override slug" do
      @page.url.should eql('/')
      @page.slug = "some-slug"
      @page.url.should eql('/')
    end
  end

  
  describe ".find_by_url" do
    it "should alias methods" do
      Page.should respond_to(:find_by_url_with_sites)
      Page.should respond_to(:find_by_url_without_sites)
      Page.should respond_to(:current_site)
      Page.should respond_to(:current_site=)
    end
    
    it "should respect defaults" do
      Page.current_site = nil
      assert_equal pages(:home), Page.find_by_url("/")
    end
    
    it "should find site-scoped pages" do
      Page.current_site = sites(:mysite)
      assert_equal pages(:home), Page.find_by_url("/")
      assert_equal pages(:news), Page.find_by_url("/news")
    end
    
    it "should not find a page in a site with no homepage" do
      lambda do
        Page.current_site = sites(:yoursite)
        Page.find_by_url("/")
      end.should raise_error(Page::MissingRootPageError)
    end
  end
  
  describe "#destroy" do
    it "should nullify homepage_id" do
      sites(:mysite).homepage_id.should_not be_nil
      pages(:home).destroy
      sites(:mysite).reload.homepage_id.should be_nil
    end
  end

end