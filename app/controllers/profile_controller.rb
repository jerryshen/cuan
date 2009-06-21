class ProfileController < ApplicationController

  def self_salary
  end

  def ajax_total_list
    if params[:date_month].blank?
      conditions = ["user_id = ? and year = ?",@current_user.id, params[:date_year]]
    else
      conditions = ["user_id = ? and year = ? and month = ?", @current_user.id, params[:date_year], params[:date_month]]
    end

    unless @current_user.is_retired
      @basic_salaries = BasicSalaryRecord.find(:all,:order => "id DESC", :conditions => conditions)
      @college_benefits = CollegeBeRecord.find(:all, :order => "id DESC", :conditions => conditions)
      @fee_cuttings = FeeCuttingRecord.find(:all, :order => "id DESC", :conditions => conditions)
    else
      @basic_salaries = RetiredBasicSalaryRecord.find(:all, :order => "id DESC", :conditions => conditions)
      @college_benefits = RetiredCollegeBeRecord.find(:all, :order => "id DESC", :conditions => conditions)
      @fee_cuttings = RetiredFeeCuttingRecord.find(:all, :order => "id DESC", :conditions => conditions)
    end
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
