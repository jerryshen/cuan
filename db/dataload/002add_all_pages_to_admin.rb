class AddAllPagesToAdmin < ActiveRecord::Migration
  def self.up
    admin_id = Role.first.id
    Page.find_all_by_page_module_id(3).each do |page|
      PageRole.create(:page_id => page.id, :role_id => admin_id)  
    end
  end

  def self.down
    Page.find_all_by_page_module_id(3).each do |page|
      PageRole.find_by_page_id(page.id).delete
    end
  end
end
