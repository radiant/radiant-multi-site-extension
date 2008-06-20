module SitesHelper
  def order_links(site)
    returning String.new do |output|
      output << link_to(image("move_to_top.png", :alt => "Move to top"), move_to_top_site_path(site), :method => :put)
      output << link_to(image("move_higher.png", :alt => "Move up"), move_higher_site_path(site), :method => :post)
      output << link_to(image("move_lower.png", :alt => "Move down"), move_lower_site_path(site), :method => :post)
      output << link_to(image("move_to_bottom.png", :alt => "Move to bottom"), move_to_bottom_site_path(site), :method => :put)
    end
  end
end
