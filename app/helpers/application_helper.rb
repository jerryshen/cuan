# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  #列出教职工中的离退休人员
  def get_retired_staffs
    User.find(:all, :conditions => ["is_retired = 1"])
  end

  #列出在职的教职工
  def get_comm_staffs
    User.find(:all, :conditions => ["is_retired = 0"])
  end
end
