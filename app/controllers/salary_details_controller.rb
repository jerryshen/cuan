class SalaryDetailsController < ApplicationController

  def index
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @salary_details }
      format.json { render :text => get_json }
    end
  end

  private

  def get_json
    load_page_data
    department = params[:search_department]
    user       = params[:search_user]
    year       = params[:search_year]
    month      = params[:search_month]

    data = SalaryDetail.view_inc_salaries

    conditions = '1==1'
    if(!department.blank?)
      conditions << ' && User.find(x["user_id"]).department_id.to_s == department' 
    end
    
    if(!user.blank?)
      conditions << ' && x["user_id"].to_s == user'
    end
    
    if(!year.blank?)
      conditions << ' && x["year"] == year'
    end
    
    if(!month.blank?)
      conditions << ' && x["month"] == month'
    end

    if(conditions != '1==1')
      arr_data = data.select{|x| eval(conditions) }
      @salary_details = arr_data.paginate(:per_page=> @pagesize,:page => params[:page] || 1)
      count = arr_data.count
    else
      @salary_details = data.paginate(:per_page=> @pagesize,:page => params[:page] || 1)
      count = data.count
    end
    return hash_to_json(@salary_details,count)
  end

end
