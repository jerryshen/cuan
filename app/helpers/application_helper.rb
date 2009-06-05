# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  #users for select
  def users_for_select
    User.all.collect {|p| [ p.name, p.id ] }
  end

  #departments for select
  def departments_for_select
    Department.all.collect {|p| [ p.name, p.id ] }
  end

  #titles for select
  def titles_for_select
    Title.all.collect {|p| [ p.name, p.id ] }
  end

  #positions for select
  def positions_for_select
    Position.all.collect {|p| [ p.name, p.id ] }
  end

  #banks for select
  def banks_for_select
    Bank.all.collect {|p| [ p.name, p.id ] }
  end

  #列出教职工中的离退休人员
  def get_retired_staffs
    User.find(:all, :conditions => ["is_retired = 1"])
  end

  #列出在职的教职工
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
end
