module ScienceBeSciencesHelper
  #list science department staffs
  def get_science_staffs
    department_name = "科研处"
    users = Department.find_by_name(department_name).users
    return users
  end
end
