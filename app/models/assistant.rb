class Assistant < ActiveRecord::Base
  belongs_to :user

  #validations
  validates_presence_of :user_id, :benefit

end
