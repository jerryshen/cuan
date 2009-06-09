class AddDefaultRoles < ActiveRecord::Migration
  def self.up
    Role.create( :name => '超级管理员')
    admin = Role.first
    Page.find(:all, :conditions => ["page_module_id = 1 or page_module_id = 2"]).each do |page|
      PageRole.create( :page_id => page.id, :role_id => admin.id)
    end
  end

  def self.down
  end
end
