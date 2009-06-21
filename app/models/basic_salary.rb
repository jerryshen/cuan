class BasicSalary < ActiveRecord::Base
  belongs_to :user

  #validation
  validates_presence_of :user_id, :message => "教职工不能为空！"
  validates_presence_of :station_sa, :position_sa
  validates_numericality_of :station_sa, :position_sa

end
