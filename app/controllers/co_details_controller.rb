class CoDetailsController < ApplicationController
  def index
    @departments = Department.all.collect { |d| [d.name, d.id] }
  end

  def select_with_ajax
    conditions = ["department_id = ?", params[:department_id]]
    @users = User.find(:all, :conditions => conditions).collect { |u| [u.name, u.id] }
  end

  def ajax_total_list
    year = params[:date_year]
    month = params[:date_month]
    user_id = params[:user_id]
    department_id = params[:department_id]

    unless user_id.blank?
      @selected_user = User.find(user_id)
    else
      @selected_user = User.find(:first, :conditions => ["department_id =?", department_id])
    end

    conditions = CoDetail.get_conditions(user_id, year, month)
    unless @selected_user.is_retired
      @basic_salaries = BasicSalaryRecord.find(:all,:order => "id DESC", :conditions => conditions)
      @college_benefits = CollegeBeRecord.find(:all, :order => "id DESC", :conditions => conditions)
      @fee_cuttings = FeeCuttingRecord.find(:all, :order => "id DESC", :conditions => conditions)
    else
      @basic_salaries = RetiredBasicSalaryRecord.find(:all, :order => "id DESC", :conditions => conditions)
      @college_benefits = RetiredCollegeBeRecord.find(:all, :order => "id DESC", :conditions => conditions)
      @fee_cuttings = RetiredFeeCuttingRecord.find(:all, :order => "id DESC", :conditions => conditions)
    end
  end
  
end
