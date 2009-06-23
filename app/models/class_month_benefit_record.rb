class ClassMonthBenefitRecord < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id
  validates_numericality_of :fee

end
