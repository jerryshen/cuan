module ScienceBeSciencesHelper
  #list science department staffs
  def get_science_staffs
    department_name = "科研处"
    users = Department.find_by_name(department_name).users
    return users
  end

  def current_admin?
    name = "超级管理员"
    return true if @current_user.roles.find_by_name(name)
  end
end
