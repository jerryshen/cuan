class BankCard < ActiveRecord::Base
  #mapping
  belongs_to :bank
  belongs_to :user

  #validations
  validates_presence_of :user_id, :bank_id, :card_number
#  validates_uniqueness_of :card_number
#  validates_length_of :card_number, :is => 19
  
end
