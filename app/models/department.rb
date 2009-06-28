class Department < ActiveRecord::Base
  #mapping
  has_many :users

  #validations
  validates_presence_of :name
  validates_uniqueness_of :name

  def self.all_users_json
    hash = []
    find_by_sql("select id,name from departments").each do |row|
      users = row.users.collect{ |u| {:id => u.id, :name => u.name} }
      hash << {:id => row.id, :name => row.name, :users => users}
    end
    return hash
  end

  def users_to_json
    ar_users = users.collect do |row|
      {:id => row.id, :name => row.name}
    end
    ar_users.to_json
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
