class StationPositionBenefit < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id
  validates_numericality_of [:station_be, :position_be], :allow_nil => true
end
