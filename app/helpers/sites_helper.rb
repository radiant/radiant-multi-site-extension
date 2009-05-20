module SitesHelper
  def order_links(site)
    returning String.new do |output|
      output << link_to(image("move_to_top.png", :alt => "Move to top"), move_to_top_admin_site_path(site), :method => :put)
      output << link_to(image("move_higher.png", :alt => "Move up"), move_higher_admin_site_path(site), :method => :post)
      output << link_to(image("move_lower.png", :alt => "Move down"), move_lower_admin_site_path(site), :method => :post)
      output << link_to(image("move_to_bottom.png", :alt => "Move to bottom"), move_to_bottom_admin_site_path(site), :method => :put)
    end
  end
end
