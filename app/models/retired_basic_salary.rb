class RetiredBasicSalary < ActiveRecord::Base
  belongs_to :user

  #validation
  validates_presence_of :user_id, :message => "教职工不能为空！"
  validates_presence_of :basic_fee, :message => "基本工资不能为空！"
end
