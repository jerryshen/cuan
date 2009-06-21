class Assistant < ActiveRecord::Base
  belongs_to :user

  #validation
  validates_presence_of :user_id, :benefit

end
