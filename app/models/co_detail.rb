class CoDetail
  #get total counting by year/month or entire/department
  def self.get_counting(year, month)
    reg = ""
    reg << "aa.station_sa + aa.position_sa + aa.station_be + aa.foreign_be + aa.region_be + aa.hard_be + aa.stay_be"
    reg << " - bb.room_fee - bb.med_fee - bb.elc_fee - bb.net_fee - bb.job_fee - bb.selfedu_fee - bb.other_fee1 - bb.other_fee2 - bb.other_fee3 - bb.self_tax"
    reg << " + cc.life_be + cc.diff_be + cc.livesa_be + cc.tv_be + cc.beaulty_be + cc.other_be"
    sql = ""
    sql << "SELECT SUM(#{reg}) counting FROM basic_salary_records as aa"
    sql << " INNER JOIN fee_cutting_records as bb INNER JOIN college_be_records as cc"
    sql << " ON aa.user_id = bb.user_id = cc.user_id"
    sql << " WHERE (aa.year = #{year} and bb.year = #{year} and cc.year = #{year} and aa.month = #{month} and bb.month = #{month} and cc.month = #{month})"
    sql << " GROUP BY aa.user_id"
    data = BasicSalaryRecord.find_by_sql(sql)
    return data.counting
  end

  def self.get_retired_counting(year, month)
    #to do
  end
end
