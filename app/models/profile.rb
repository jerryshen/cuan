class Profile
  def self.get_view_conditions(year, month, user_id)
    conditions = "user_id = #{user_id}"
    condition_values = []
    if(!year.blank?)
      conditions += " AND year = ?"
      condition_values << year
    end
    if(!month.blank?)
      conditions += " AND month = ?"
      condition_values << month
    end
    if(conditions != "user_id = #{user_id}")
      option_conditions = [conditions, condition_values].flatten!
    else
      option_conditions = []
    end
    return option_conditions
  end

  def self.get_salary_data(year, month, user_id, retired)
    conditions = Profile.get_view_conditions(year, month, user_id)
    case retired
    when false
      sa_data = BasicSalaryRecord.find(:all, :conditions => conditions )
    when true
      sa_data = RetiredBasicSalaryRecord.find(:all, :conditions => conditions )
    end
    return sa_data
  end

  def self.get_fee_cutting_data(year, month, user_id, retired)
    conditions = Profile.get_view_conditions(year, month, user_id)
    case retired
    when false
      f_c_data = FeeCuttingRecord.find(:all, :conditions => conditions)
    when true
      f_c_data = RetiredFeeCuttingRecord.find(:all, :conditions => conditions)
    end
    return f_c_data
  end

  def self.get_benefit_data(year, month, user_id, retired)
    conditions = Profile.get_view_conditions(year, month, user_id)
    case retired
    when false
      be_data = CollegeBenefit.find(:all, :conditions => conditions)
    when true
      be_data = RetiredCollegeBeRecord.find(:all, :conditions => conditions)
    end
    return be_data
  end
end
