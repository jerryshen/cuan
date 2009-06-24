class RetiredCollegeBeRecord < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id, :year, :month
  validates_numericality_of [:diff_be, :tv_be, :beaulty_be, :other_be1, :other_be3], :allow_nil => true
  
end
