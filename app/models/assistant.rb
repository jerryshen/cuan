class Assistant < ActiveRecord::Base
  belongs_to :user
  belongs_to :department


  def self.to_json
    hash = {}
    find_by_sql("select aa.id,bb.name from assistants as aa inner join users as bb where aa.user_id=bb.id").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end

end
