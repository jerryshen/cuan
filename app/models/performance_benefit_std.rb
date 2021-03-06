class PerformanceBenefitStd < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id
  validates_uniqueness_of :user_id
  validates_numericality_of :std_fee

end
