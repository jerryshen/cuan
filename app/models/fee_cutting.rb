class FeeCutting < ActiveRecord::Base
  belongs_to :user

  #validation
  validates_presence_of :user_id, :message => "教职工不能为空！"
end
