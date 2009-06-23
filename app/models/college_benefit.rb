class CollegeBenefit < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id
  validates_numericality_of [:life_be, :diff_be, :livesa_be, :tv_be, :beaulty_be],
                            :allow_nil => true

end
