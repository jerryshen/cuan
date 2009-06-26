class DataExport

  #get incumbency salary data by year/month
  def self.get_salary_data(year,month)
    reg = ""
    reg << "aa.station_sa + aa.position_sa + aa.station_be + aa.foreign_be + aa.region_be + aa.hard_be + aa.stay_be "
    reg << "- bb.room_fee - bb.med_fee - bb.elc_fee - bb.net_fee - bb.job_fee - bb.selfedu_fee - bb.other_fee1 - bb.other_fee2 - bb.other_fee3 - bb.self_tax"
    sql = ""
    sql << "SELECT aa.user_id,(#{reg}) salary  FROM basic_salary_records as aa INNER JOIN fee_cutting_records as bb ON bb.user_id = aa.user_id "
    sql << " WHERE (aa.year = #{year} and bb.year = #{year} and aa.month = #{month} and bb.month = #{month}) ORDER BY aa.user_id"
    BasicSalaryRecord.find_by_sql(sql)
  end

  #get incumbency college benefit data by year/month
  def self.get_benefit_data(year, month)
    reg = "cc.life_be + cc.diff_be + cc.livesa_be + cc.tv_be + cc.beaulty_be + cc.other_be"
    sql = ""
    sql << "SELECT cc.user_id, (#{reg}) benefit FROM college_be_records as cc "
    sql << " WHERE (cc.year = #{year} and cc.month = #{month})"
    CollegeBeRecord.find_by_sql(sql)
  end

  #get retired salary data by year/month
  def self.get_retired_salary_data(year, month)
    reg = ""
    reg << "aa.basic_fee + aa.stay_be + aa.foreign_be + aa.region_be"
    reg << " - bb.other_fee1 - bb.other_fee2 - bb.other_fee3"
    sql = ""
    sql << "SELECT aa.user_id, (#{reg}) retired_salary FROM retired_basic_salart_records as aa "
    sql << " INNER JOIN retired_fee_cutting_records as bb ON aa.user_id = bb.user_id"
    sql << " WHERE (aa.year = #{year} and bb.year = #{year} and aa.month = #{month} and bb.month = #{month})"
    sql << "ORDER BY aa.user_id"
    RetiredBasicSalaryRecord.find_by_sql(sql)
  end

  #get retired benefit data by year/month
  def self.get_retired_benefit_data(year, month)
    reg = "cc.diff_be + cc.tv_be + cc.beaulty_be + cc.other_be1 + cc.other_be3"
    sql = ""
    sql << "SELECT cc.user_id, (#{reg}) retired_benefit FROM retired_college_be_records as cc"
    sql << " WHERE (cc.year = #{year} and cc.month = #{month})"
    RetiredCollegeBeRecord.find_by_sql(sql)
  end

end