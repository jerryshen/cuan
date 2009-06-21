class AppConfig < ActiveRecord::Base


  #validations
  #  ALIAS = '系统参数配置'
  #  COLUMN_ALIASES = {
  #    'key' => '键',
  #    'value' => '值'
  #  }
  validates_presence_of :key, :value


  #APP CONFIG get value by key
  def self.get(key)
    config = find_by_key(key)
    return config.nil? ? "" : config.value
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
