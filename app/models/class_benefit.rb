class ClassBenefit < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id, :term, :month
  validates_numericality_of :total_be

  before_destroy :destroyable
  before_update :re_verify

  #verify(field: is_varified)
  #Science.first.verify
  def verify
    self.update_attributes(:is_verified => !self.is_verified)
  end

  def destroyable
    raise "can't destroy" if self.is_verified == true
  end

  def re_verify
    raise "can't re-verify" if self.is_verified == false
  end

  #find users in a same department with edu
  def self.get_department_user_ids(user_id)
    @user_ids = []
    @users = User.find(user_id).department.users
    @users.each do |u|
      @user_ids.push(u.id)
    end
    return @user_ids.join(",")
  end
  
end
