class Education < ActiveRecord::Base

  def self.to_json
    hash = {}
    find_by_sql("select id,name from educations").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end
end
