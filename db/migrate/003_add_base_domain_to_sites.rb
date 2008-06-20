class AddBaseDomainToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :base_domain, :string
    Site.reset_column_information
    Site.update_all "base_domain = 'tempdomain'"
  end
  
  def self.down
    remove_column :sites, :base_domain
  end
end
