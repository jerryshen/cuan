module ClassBeEdusHelper
  
  #get persons belongs to the same department
  def get_department_persons
    unless @current_user.nil?
      User.find(:all,:conditions => ["department_id = ?",@current_user.department.id])
    else
      return nil
    end
  end
end
