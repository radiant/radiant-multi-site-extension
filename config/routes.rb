ActionController::Routing::Routes.draw do |map|
  map.namespace :admin, :member => { :remove => :get } do |admin|
    admin.resources :sites, :member => {
      :move_higher => :post,
      :move_lower => :post,
      :move_to_top => :put,
      :move_to_bottom => :put
    }
  end
end
