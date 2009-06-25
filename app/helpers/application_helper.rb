# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  #select options for index searching
  def list_departments_for_search
    @options = [["所有",""]]
    Department.find_by_sql("select id,name from departments").each do |row|
      ar=[]
      ar << row.attributes["name"].to_s
      ar << row.attributes["id"].to_s
      @options << ar
    end
  end
  
  #get retired staffs list
  def get_retired_staffs
    User.find(:all, :conditions => ["is_retired = 1"])
  end

  #get common staffs list
  def get_comm_staffs
    User.find(:all, :conditions => ["is_retired = 0"])
  end

  #fuzzy time
  def fuzzy_time(time)
    time.strftime("%Y") + " 年 " + time.strftime("%m").to_i.to_s + " 月 " + time.strftime("%d").to_i.to_s + " 日 "
  end

  #fuzzy gender
  def fuzzy_gender(gender)
    gender.to_s == "m" ? "男" : "女"
  end

  #get persons belongs to the same department
  def get_department_persons
    unless @current_user.nil?
      User.find(:all,:conditions => ["department_id = ?",@current_user.department.id])
    else
      return nil
    end
  end

  def current_admin?
    name = "超级管理员"
    return true if @current_user.roles.find_by_name(name)
  end
  
  #ajax pagination for will_paginate plugin
  def will_paginate_remote(paginator, options={})
    update = options.delete(:update)
    url = options.delete(:url)
    str = will_paginate(paginator, options)
    if str != nil
      str.gsub(/href="(.*?)"/) do
        "href=\"#\" onclick=\"new Ajax.Updater('" + update + "', '" + (url ? url + $1.sub(/[^\?]*/, '') : $1) +
          "', {asynchronous:true, evalScripts:true, method:'get',}); return false;\""
      end
    end
  end
end
