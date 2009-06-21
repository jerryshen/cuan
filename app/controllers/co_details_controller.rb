class CoDetailsController < ApplicationController
  
  def index
    @departments = Department.all.collect { |d| [d.name, d.id] }
  end


  def select_with_ajax
    conditions = ["department_id = ?", params[:department_id]]
    @users = User.find(:all, :conditions => conditions).collect { |u| [u.name, u.id] }
  end

  def ajax_total_list
    unless params[:user_id].blank?
      @selected_user = User.find(:first, :conditions => ["id =?",params[:user_id]]) if params[:user_id]
    else
      @selected_user = User.find(:first, :conditions => ["department_id =?", params[:department_id]])
    end
    if params[:date_month].blank?
      conditions = ["user_id = ? and year = ?", params[:user_id], params[:date_year]]
    else
      conditions = ["user_id = ? and year = ? and month = ?", params[:user_id], params[:date_year], params[:date_month]]
    end

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
