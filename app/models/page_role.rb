class PageRole < ActiveRecord::Base
  #mapping
  belongs_to :page, :class_name => 'Page', :foreign_key => 'page_id'
  belongs_to :role, :class_name => 'Role', :foreign_key => 'role_id'

  #validations
  validates_presence_of :page_id, :message => "页面不能为空！"
  validates_presence_of :role_id, :message => "角色不能为空！"
  
end
