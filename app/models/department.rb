class Department < ActiveRecord::Base
  #mapping
  has_many :users

  #validations
  validates_presence_of :name, :message => "部门名称不能为空！"
  validates_uniqueness_of :name, :message => "部门名称不能重复！"

  def self.all_users_json
    hash = []
    find_by_sql("select id,name from departments").each do |row|
      users = row.users.collect{ |u| {:id => u.id, :name => u.name} }
      hash << {:id => row.id, :name => row.name, :users => users}
    end
    return hash
  end

  def self.to_hash
    hash = {}
    find_by_sql("select id,name from departments").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash
  end

  #列表中实现ID和name的切换显示
  def self.to_json
    return self.to_hash.to_json
  end
end
