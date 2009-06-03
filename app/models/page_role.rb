class PageRole < ActiveRecord::Base
  belongs_to :page, :class_name => 'Page', :foreign_key => 'page_id'
  belongs_to :role, :class_name => 'Role', :foreign_key => 'role_id'
end
