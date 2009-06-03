class User < ActiveRecord::Base
  #mapping
  belongs_to :department, :class_name => 'Department', :foreign_key => 'department_id'
  belongs_to :td_belongs, :class_name => 'Department', :foreign_key => 'department_id'
  belongs_to :title, :class_name => 'Title', :foreign_key =>'title_id'
  belongs_to :position, :class_name => 'Position', :foreign_key => 'position_id'

  has_many :role_users
  has_many :roles, :through => :role_users, :class_name => 'Role', :foreign_key => 'role_id'

  has_many :bank_cards

  #列表中实现ID和name的切换显示
  def self.to_json
    hash = {}
    find_by_sql("select id,name from users").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end
end
