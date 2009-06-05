class Position < ActiveRecord::Base
  #mapping
  has_many :users

  #validations
  validates_presence_of :name, :message => "职务名称不能为空！"
  validates_uniqueness_of :name, :message => "职务名称不能重复！"

  #列表中实现ID和name的切换显示
  def self.to_json
    hash = {}
    find_by_sql("select id,name from positions").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end
end
