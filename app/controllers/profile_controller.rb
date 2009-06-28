class ProfileController < ApplicationController
  protect_from_forgery :except => :ajax_total_list

  def self_salary
  end

  def ajax_total_list
    year = params[:date_year]
    month = params[:date_month]
    user_id = @current_user.id
    @basic_salaries = Profile.get_salary_data(year, month, user_id, @current_user.is_retired)
    @fee_cuttings = Profile.get_fee_cutting_data(year, month, user_id, @current_user.is_retired)
    @college_benefits = Profile.get_benefit_data(year, month, user_id, @current_user.is_retired)
  end

  def my_profile
  end

  def change_my_password
  end

  def try_to_change_password
    if @current_user
      if @current_user.change_password(params[:old_password],params[:new_password])
        flash[:notice] = "密码已经成功修改"
      else
        flash[:notice] = "请检查您的密码"
      end
    end
    render :action => 'change_my_password'
  end
end
