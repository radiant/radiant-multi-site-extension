class SitesDataset < Dataset::Base
  uses :pages
  
  def load
    create_record Site, :mysite, :name => 'My Site', :domain => 'mysite.domain.com', :base_domain => 'mysite.domain.com', :position => 1, :homepage_id => page_id(:home)
    create_record Site, :yoursite, :name => 'Your Site', :domain => '^yoursite', :base_domain => 'yoursite.test.com', :position => 2
    create_record Site, :default, :name => 'Default', :base_domain => 'digitalpulp\.com', :position => 3
    create_record Site, :subdomain, :name => 'Subdomain', :domain => '^sub\.', :base_domain => 'sub.digitalpulp.com', :position => 4
  end
end