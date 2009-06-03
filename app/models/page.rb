class Page < ActiveRecord::Base
  #mapping
  belongs_to :page_module, :class_name => 'PageModule', :foreign_key => 'page_module_id'
  has_many :page_roles
  has_many :roles, :through => :page_roles, :class_name => 'Role', :foreign_key => 'role_id'

  #find roles who can view ths page by page name.
  def self.find_roles_by_name(name)
    self.find(:all, :conditions => ["name like ?","%#{name}%"]).roles
  end

  def self.find_roles_by_url(url)
    #to do auto_link
  end

  #列表中实现ID和name的切换显示
  def self.to_json
    hash = {}
    find_by_sql("select id,name from pages").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end
end
