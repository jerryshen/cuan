class RetiredBasicSalary < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id
  validates_numericality_of :basic_fee
  validates_numericality_of [:stay_be, :foreign_be, :region_be],
                            :allow_nil => true
  
end
