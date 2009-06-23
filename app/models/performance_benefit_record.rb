class PerformanceBenefitRecord < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id, :term
  validates_numericality_of :fee

end
