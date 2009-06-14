class AppConfig < ActiveRecord::Base
  
  #APP CONFIG get value by key
  def self.get(key)
    return find_by_key(key).value
  end
end
