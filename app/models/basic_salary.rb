class BasicSalary < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id
  validates_numericality_of :station_sa, :position_sa
  validates_numericality_of [:station_be, :foreign_be, :region_be, :hard_be, :stay_be],
                             :allow_nil => true


end
