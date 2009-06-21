module CoDetailsHelper
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
