require File.dirname(__FILE__) + '/../spec_helper'

describe Site do
  dataset :sites
  
  before do
    @site = Site.new :name => "Test Site", :domain => "test", :homepage_id => 1, :base_domain => "test.host", :homepage_id => page_id(:home)
  end
  
  it "should require a name" do
    @site.name = nil
    @site.should_not be_valid
    @site.errors.on(:name).should_not be_empty
  end
  
  it "should require a base domain" do
    @site.base_domain = nil
    @site.should_not be_valid
    assert_not_nil @site.errors.on(:base_domain)
  end
  
  it "should require unique domain" do
    @site.domain = sites(:default).domain
    @site.should_not be_valid
    @site.errors.on(:domain).should_not be_empty
  end
  
  it "should have an associated homepage" do
    @site.should respond_to(:homepage)
    @site.homepage.should eql(pages(:home))
  end
  
  it "should create a homepage on create" do
    @site.homepage_id = nil
    @site.save.should eql(true)
    @site.homepage.should_not be_nil
    @site.homepage.should be_valid
    @site.homepage.parts.each { |part| part.should be_valid }
    @site.homepage.should_not be_new_record
  end
  
  it "should find site for hostname" do
    sites(:mysite).should eql(Site.find_for_host("mysite.domain.com"))
    sites(:yoursite).should eql(Site.find_for_host("yoursite.com"))
    sites(:yoursite).should eql(Site.find_for_host("yoursite.unknown.com"))
    sites(:default).should eql(Site.find_for_host("unknown.com"))
    sites(:subdomain).should eql(Site.find_for_host("sub.unknown.com"))
    sites(:subdomain).should eql(Site.find_for_host("sub.domain.com"))
  end
  
  it "should generate site url from path" do
    sites(:mysite).url.should eql("http://mysite.domain.com/")
    sites(:mysite).url("/about").should eql("http://mysite.domain.com/about")
  end
  
  it "should generate dev site url from path" do
    sites(:mysite).dev_url.should eql("http://dev.mysite.domain.com/")
    sites(:mysite).dev_url("/about").should eql("http://dev.mysite.domain.com/about")
  end
  
  describe "#save" do
    it "should reload routes" do
      ActionController::Routing::Routes.should_receive(:reload)
      @site.save
    end
  end

end