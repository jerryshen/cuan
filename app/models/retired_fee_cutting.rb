class RetiredFeeCutting < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id
  validates_numericality_of [:other_fee1, :other_fee2, :other_fee3], :allow_nil => true
end
