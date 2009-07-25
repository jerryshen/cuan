class SalaryDetail

  #list inc users' salaries, viewed by college master
  def self.view_inc_salaries
    ar = []
    users = User.find(:all, :conditions => ["is_retired = ?",false])
    unless users.blank?
      users.each do |u|
        ar << Profile.view_salary(u.id, false)
      end
    else
      ar = []
    end
    arr = ar.flatten
    return arr
  end

  #list ret users' salaries, viewed by college master
  def self.view_ret_salaries
    ar = []
    users = User.find(:all, :conditions => ["is_retired = ?", true])
    unless users.blank?
      users.each do |u|
        ar << Profile.view_salary(u.id, true)
      end
    else
      ar = []
    end
    arr = ar.flatten
    return arr
  end
end
