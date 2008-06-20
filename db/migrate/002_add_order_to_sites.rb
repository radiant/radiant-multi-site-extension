class AddOrderToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :position, :integer, :default => 0
  end
  
  def self.down
    remove_column :sites, :position
  end
end
