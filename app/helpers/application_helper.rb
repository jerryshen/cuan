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

  #Rewrite errors messge for
  def error_messages_for(object_name, options = {})
    options = options.symbolize_keys
    object = instance_variable_get("@#{object_name}")
    if object && !object.errors.empty?
      content_tag("div",
        content_tag(
          options[:header_tag] || "h2",
          "保存该#{object.class::ALIAS}时发生#{object.errors.count}个错误。"
        ) +
          content_tag("ul", object.errors.collect { |attr, msg| content_tag("li", object.class::COLUMN_ALIASES[attr] + msg) }),
        "id" => options[:id] || "errorExplanation", "class" => options[:class] || "errorExplanation"
      )
    else
      ""
    end
  end

  #ActiveRecord::Errors.default_error_messages = {
  #  :inclusion => "没有包含在列表内",
  #  :exclusion => "是保留的",
  #  :invalid => "无效",
  #  :confirmation => "确认不匹配",
  #  :accepted  => "必须赋值",
  #  :empty => "不能为空",
  #  :blank => "不能为空",
  #  :too_long => "太长 (最长 %d 个字符)",
  #  :too_short => "太短 (最短 %d 个字符)",
  #  :wrong_length => "长度错误 (必须 %d 个字符)",
  #  :taken => "不能重复",
  #  :not_a_number => "不是数字" ,
  #  :must_number => "必须是数字",
  #  #Jespers additions:
  #  :error_translation   => "个错误",
  #  :error_header        => "保存该%2$s时发生%1$s",
  #  :error_subheader     => "错误字段如下："
  #}

end
