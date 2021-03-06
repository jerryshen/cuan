class AssistantBenefit < ActiveRecord::Base
  belongs_to :assistant

  validates_presence_of :assistant_id, :year, :month

  before_destroy :destroyable
  before_update :re_verify

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
