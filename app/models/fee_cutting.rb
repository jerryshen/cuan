class FeeCutting < ActiveRecord::Base
  belongs_to :user

  #validations
  validates_presence_of :user_id
  validates_numericality_of [:room_fee, :med_fee, :elc_fee, :net_fee, :job_fee,
                             :selfedu_fee, :other_fee1, :other_fee2, :other_fee3],
                             :allow_nil => true
end
