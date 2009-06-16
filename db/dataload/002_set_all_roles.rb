class SetAllRoles < ActiveRecord::Migration
  def self.up
    PageModule.create(:name => "个人信息",:index => "2",:description => "个人信息：修改个人密码、查看个人信息、工资")
    page_module_id = PageModule.find_by_name("个人信息").id
    Page.create(:name => "修改密码",:function => "修改密码",:url => "/profile/change_my_password", :page_module_id => page_module_id, :hidden => false)
    Page.create(:name => "查看个人信息", :function => "查看个人信息", :url => "/profile/my_profile", :page_module_id => page_module_id, :hidden => false)
  end

  def self.down
    Page.find_all_by_page_module_id(3).each do |page|
      PageRole.find_by_page_id(page.id).delete
    end
  end
end
