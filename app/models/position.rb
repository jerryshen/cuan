class Position < ActiveRecord::Base
  has_many :users

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
