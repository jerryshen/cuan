class BankCard < ActiveRecord::Base
  #mapping
  belongs_to :bank
  belongs_to :user

  #validations
  validates_presence_of :user_id, :message => "教职工不能为空！"
  validates_presence_of :bank_id, :message => "发卡银行不能为空！"
  validates_presence_of :card_number, :message => "银行卡号不能为空！"
  validates_uniqueness_of :card_number, :message => "银行卡号不能重复！"
  validates_length_of :card_number, :is => 19, :message => "银行卡号输入有误！"
  
end
