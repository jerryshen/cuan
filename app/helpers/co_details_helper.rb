module CoDetailsHelper

  #get counting title
  def content_title(year, month, department_id)
    department_name = department_id.blank? ? "全校" : Department.find(department_id).name
    content_title = year.to_s + "年度" + month.to_s + "月份" + department_name.to_s + "收入统计信息"
    return content_title
  end

  def check_user_for_salary
    unless @selected_user.is_retired
      render :partial => 'share/salary_entries'
    else
      render :partial => 'share/retired_salary_entries'
    end
  else
  end

  def check_user_for_benefit
    unless @selected_user.is_retired
      render :partial => 'share/benefit_entries'
    else
      render :partial => 'share/retired_benefit_entries'
    end
  else
  end

  def check_user_for_fee_cutting
    unless @selected_user.is_retired
      render :partial => 'share/fee_cutting_entries'
    else
      render :partial => 'share/retired_fee_cutting_entries'
    end
  else
  end
end
