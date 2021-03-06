class ScienceBenefit < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id, :year, :month
  validates_numericality_of :science_be

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
end
