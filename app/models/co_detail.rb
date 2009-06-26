class CoDetail
  #get total counting by year/month/department_id or entire/department
  def self.get_counting(year, month, department_id, is_nature)
    if department_id.blank?
      sql_department = ""
    else
      sql_department = "aa.user_id in (SELECT id FROM users WHERE department_id = #{department_id})  AND "
    end
    reg = ""
    reg << "aa.station_sa + aa.position_sa + aa.station_be + aa.foreign_be + aa.region_be + aa.hard_be + aa.stay_be"
    reg << " - bb.room_fee - bb.med_fee - bb.elc_fee - bb.net_fee - bb.job_fee - bb.selfedu_fee - bb.other_fee1 - bb.other_fee2 - bb.other_fee3 - bb.self_tax"
    reg << " + cc.life_be + cc.diff_be + cc.livesa_be + cc.tv_be + cc.beaulty_be + cc.other_be"
    sql = ""
    sql << "SELECT COUNT(aa.user_id) numbers ,SUM(#{reg}) counting FROM basic_salary_records as aa"
    sql << " INNER JOIN fee_cutting_records as bb INNER JOIN college_be_records as cc"
    sql << " ON aa.user_id = bb.user_id = cc.user_id"
    sql << " WHERE (#{sql_department} aa.year = #{year} AND bb.year = #{year} AND cc.year = #{year} AND aa.month = #{month} AND bb.month = #{month} AND cc.month = #{month})"
    sql << " GROUP BY aa.user_id"
    data = BasicSalaryRecord.find_by_sql(sql)
    arr = []
    data.each do |d|
      arr << d.numbers << d.counting
    end
    total_fee = arr[1].to_f
    numbers = arr[0].to_i
    avg_fee = (total_fee / numbers).round(2)
    @arr = [numbers, total_fee, avg_fee]
  end


  def self.get_retired_counting(year, month, department_id)
    if department_id.blank?
      sql_department = ""
    else
      sql_department = "aa.user_id in (SELECT id FROM users WHERE department_id = #{department_id})  AND "
    end
    reg = ""
    reg << "aa.basic_fee + aa.stay_be + aa.foreign_be + aa.region_be - bb.other_fee1 - bb.other_fee2 - bb.other_fee3"
    reg << " cc.diff_be + cc.tv_be + cc.beaulty_be + cc.other_be1 + cc.other_be3"
    sql = ""
    sql << "SELECT COUNT(aa.user_id) numbers, (#{reg}) retired_counting FROM retired_basic_salart_records as aa"
    sql << " INNER JOIN retired_fee_cutting_records as bb INNER JOIN retired_college_be_records as cc"
    sql << " ON aa.user_id = bb.user_id = cc.user_id "
    sql << " WHERE (#{sql_department} aa.year = #{year} AND bb.year = #{year} AND cc.year = #{year}"
    sql << " AND aa.month = #{month} AND bb.month = #{month} AND cc.month = #{month})"
    sql << " GROUP BY aa.user_id"
    data = RetiredBasicSalaryRecord.find_by_sql(sql)
    arr = []
    data.each do |d|
      arr << d.numbers << d.retired_counting
    end
    total_fee = arr[1].to_f
    numbers = arr[0].to_i
    avg_fee = (total_fee / numbers).round(2)
    @arr = [numbers, total_fee, avg_fee]
  end
end