class Admin::SitesController < Admin::ResourceController
  helper :sites
  
  %w(move_higher move_lower move_to_top move_to_bottom).each do |action|
    define_method action do
      model.send(action)
      response_for :update
    end
  end
end
