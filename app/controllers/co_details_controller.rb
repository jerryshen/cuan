class CoDetailsController < ApplicationController
  def index
    @departments = Department.all.collect { |d| [d.name, d.id] }

    conditions = ["user_id = ?", params[:user][:id]] if params[:department_id]
    unless @current_user.is_retired
      @self_basic_salaries = BasicSalary.find(:all, :order => "id DESC", :conditions => conditions)
      @self_college_benefits = CollegeBenefit.find(:all, :order => "id DESC", :conditions => conditions)
      @self_fee_cuttings = FeeCutting.find(:all, :order => "id DESC", :conditions => conditions)
    else
      @every_basic_salaries = RetiredBasicSalary.find(:all, :order => "id DESC", :conditions => conditions)
      @self_college_benefits = RetiredCollegeBenefit.find(:all, :order => "id DESC", :conditions => conditions)
      @self_fee_cuttings = RetiredFeeCutting.find(:all, :order => "id DESC", :conditions => conditions)
    end
  end

  def select_with_ajax
    conditions = ["department_id = ?", params[:department_id]]
    @users = User.find(:all, :conditions => conditions).collect { |u| [u.name, u.id] }
  end

  private
  def get_json_for_salary

  end

  def get_json_for_benefits

  end

  def get_json_for_fee_cutting

  end
  

end
