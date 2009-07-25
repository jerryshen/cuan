class ProfilesController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.xml  { render :xml => @profiles }
      format.json { render :text => get_json }
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

  private

  def get_json
    load_page_data
    year  = params[:search_year]
    month = params[:search_month]
    user_id = @current_user.id
    retired = @current_user.is_retired

    data = Profile.view_salary(user_id, retired)

    conditions = "1==1"
    if(!year.blank?)
      conditions << ' && x["year"] == year'
    end

    if(!month.blank?)
      conditions << ' && x["month"] == month'
    end

    if(conditions != '1==1')
      arr_data = data.select{|x| eval(conditions) }
      @profiles = arr_data.paginate(:per_page=> @pagesize,:page => params[:page] || 1)
      count = arr_data.count
    else
      @profiles = data.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = data.count
    end
    return hash_to_json(@profiles,count)
  end
end
