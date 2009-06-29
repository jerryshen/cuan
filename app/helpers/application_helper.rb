# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def app_name
    return "四川建筑职业技术学院个人收入管理信息系统"
  end

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
      User.find(:all,:conditions => ["department_id = ?",@current_user.department_id])
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

  def select_user(name="user_id")
    options = Department.all.collect{|x| "<option value='#{x.id}' >#{x.name}</option>"}.join('')
    html = %q{
      <p>
        <label for="select_department_id">部门</label>
        <select id="select_department_id" class="required">
          <option value='' >选择部门...</option>
          <options>
        </select>
      </p>
      <p>
        <label for="select_user_id">教职工</label>
        <select id="select_user_id" disabled="disabled" name="<name>" class="required">
          <option value='' >选择教职工...</option>
        </select>
      </p>
      <script>
        jQuery("#select_department_id").bind("change",function(){
          var v = this.value;
          var select = document.getElementById("select_user_id");
          select.disabled = true;
          jQuery(select).empty();
          var option = document.createElement("option");
          option.setAttribute("value",'');
          option.text = "选择教职工...";
          select.options.add(option);
          if(v){
            jQuery.ajax({
              url: "/departments/users_to_json",
              data: {id: v},
              type: "POST",
              success: function(data){
                var users = Ext.util.JSON.decode(data); 
                for(var i=0, l=users.length; i<l; i++){
                  var option = document.createElement("option");
                  var u = users[i];
                  option.setAttribute("value",u.id);
                  option.text = u.name;
                  select.options.add(option);
                }
                select.disabled = false;
              }
            })
          }else{
            select.disabled = true;
          }
        })
      </script>
    }
    html.sub!("<options>",options).sub!("<name>",name)
  end

end
