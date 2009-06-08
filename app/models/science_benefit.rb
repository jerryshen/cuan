class ScienceBenefit < ActiveRecord::Base
  #mapping
  belongs_to :user

  #verify(field: is_varified)
  #Science.first.verify
  def verify
    self.update_attributes(:is_verified => !self.is_verified)
  end

end
