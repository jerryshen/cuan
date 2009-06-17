class AppConfig < ActiveRecord::Base
  
  #APP CONFIG get value by key
  def self.get(key)
    return find_by_key(key).value
  end

  def self.set(key,value)
    config = find_by_key(key)
    if config.nil?
      config = new({:key=>key})
    end
    config.value = value
    config.save
  end
end
