class CoDetail
  #get total counting by year/month/department_id/is_nature or entire/department
  def self.get_counting(year, month, department_id, is_nature)
    if(department_id.blank? && is_nature.blank?)
      sql_condition = ""
    elsif(!department_id.blank? && is_nature.blank?)
      sql_condition = "aa.user_id in (SELECT id FROM users WHERE department_id = #{department_id})  AND "
    elsif(department_id.blank? && !is_nature.blank?)
      sql_condition = "aa.user_id in (SELECT id FROM users WHERE is_nature = #{is_nature}) AND "
    else
      sql_condition = "aa.user_id in (SELECT id FROM users WHERE department_id = #{department_id} AND is_nature = '#{is_nature}') AND "
    end
    reg = ""
    reg << "aa.station_sa + aa.position_sa + aa.station_be + aa.foreign_be + aa.region_be + aa.hard_be + aa.stay_be"
    reg << " - bb.room_fee - bb.med_fee - bb.elc_fee - bb.net_fee - bb.job_fee - bb.selfedu_fee - bb.other_fee1 - bb.other_fee2 - bb.other_fee3 - bb.self_tax"
    reg << " + cc.life_be + cc.diff_be + cc.livesa_be + cc.tv_be + cc.beaulty_be + cc.other_be"
    sql = ""
    sql << "SELECT aa.user_id,#{reg} counting FROM basic_salary_records as aa"
    sql << " INNER JOIN fee_cutting_records as bb INNER JOIN college_be_records as cc"
    sql << " ON aa.user_id = bb.user_id = cc.user_id"
    sql << " WHERE (#{sql_condition} aa.year = #{year} AND bb.year = #{year} AND cc.year = #{year} AND aa.month = #{month} AND bb.month = #{month} AND cc.month = #{month})"
    sql << " GROUP BY aa.user_id"
    data = BasicSalaryRecord.find_by_sql(sql)
    unless data.blank?
      total = 0
      data.each do |d|
        total += d.counting.to_f
      end
      numbers = data.count
      avg = (total / numbers).round(2)
      top = data.sort_by {|t| t.counting}.sort.reverse.first
      bot = data.sort_by {|t| t.counting}.sort.reverse.last
      arr = [numbers, total, avg, top, bot]
    else
      arr = []
    end
    return arr
  end

  #get retired total counting by year/month/department_id/is_nature or entire/department
  def self.get_retired_counting(year, month, department_id, is_nature)
    if(department_id.blank? && is_nature.blank?)
      sql_condition = ""
    elsif(!department_id.blank? && is_nature.blank?)
      sql_condition = "aa.user_id in (SELECT id FROM users WHERE department_id = #{department_id})  AND "
    elsif(department_id.blank? && !is_nature.blank?)
      sql_condition = "aa.user_id in (SELECT id FROM users WHERE is_nature = #{is_nature}) AND "
    else
      sql_condition = "aa.user_id in (SELECT id FROM users WHERE department_id = #{department_id} AND is_nature = '#{is_nature}') AND "
    end
    reg = ""
    reg << "aa.basic_fee + aa.stay_be + aa.foreign_be + aa.region_be - bb.other_fee1 - bb.other_fee2 - bb.other_fee3"
    reg << " + cc.diff_be + cc.tv_be + cc.beaulty_be + cc.other_be1 + cc.other_be2 + cc.other_be3"
    sql = ""
    sql << "SELECT aa.user_id, (#{reg}) counting FROM retired_basic_salary_records as aa"
    sql << " INNER JOIN retired_fee_cutting_records as bb INNER JOIN retired_college_be_records as cc"
    sql << " ON aa.user_id = bb.user_id = cc.user_id "
    sql << " WHERE (#{sql_condition} aa.year = #{year} AND bb.year = #{year} AND cc.year = #{year}"
    sql << " AND aa.month = #{month} AND bb.month = #{month} AND cc.month = #{month})"
    sql << " GROUP BY aa.user_id"
    data = RetiredBasicSalaryRecord.find_by_sql(sql)
    unless data.blank?
      total = 0
      data.each do |d|
        total += d.counting.to_f
      end
      nums = data.count
      avg = (total / nums).round(2)
      top = data.sort_by {|t| t.counting}.sort.reverse.first
      bot = data.sort_by {|t| t.counting}.sort.reverse.last
      arr = [nums, total, avg, top, bot]
    else
      arr = []
    end
    return arr
  end

  #get salary view condition
  def self.get_conditions(user_id, year, month)
    conditions = "user_id = #{user_id}"
    condition_values = []

    if(!year.blank?)
      conditions += " AND year = ?"
      condition_values << year
    end

    if(!month.blank?)
      conditions += " AND month = ?"
      condition_values << month
    end

    if(conditions != "user_id = #{user_id}")
      option_conditions = [conditions,condition_values].flatten!
    else
      option_conditions = []
    end
    return option_conditions
  end
  
end