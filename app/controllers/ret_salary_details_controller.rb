class RetSalaryDetailsController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.xml  { render :xml => @ret_salary_details }
      format.json { render :text => get_json }
    end
  end

  private

  def get_json
    load_page_data
    user       = params[:search_user]
    year       = params[:search_year]
    month      = params[:search_month]

    data = SalaryDetail.view_ret_salaries

    conditions = '1==1'
    if(!user.blank?)
      user_id = User.find(:first, :conditions => ["name like ?", "%#{user}%"])
      conditions << ' && x["user_id"] == user_id'
    end

    if(!year.blank?)
      conditions << ' && x["year"] == year'
    end

    if(!month.blank?)
      conditions << ' && x["month"] == month'
    end

    if(conditions != '1==1')
      arr_data = data.select{|x| eval(conditions) }
      @ret_salary_details = arr_data.paginate(:per_page=> @pagesize,:page => params[:page] || 1)
      count = arr_data.count
    else
      @ret_salary_details = data.paginate(:per_page=> @pagesize,:page => params[:page] || 1)
      count = data.count
    end
    return hash_to_json(@ret_salary_details,count)
  end

end
