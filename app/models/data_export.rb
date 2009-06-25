class DataExport

  #get slary data by year/month
  def self.get_salary_data(year,month)
    reg = "aa.station_sa + aa.position_sa + aa.station_be + aa.foreign_be + aa.region_be + aa.hard_be + aa.stay_be - bb.room_fee - bb.med_fee - bb.elc_fee - bb.net_fee - bb.job_fee - bb.selfedu_fee - bb.other_fee1 - bb.other_fee2 - bb.other_fee3 - bb.self_tax"
    sql = "SELECT aa.user_id,(#{reg}) salary  FROM basic_salary_records as aa LEFT OUTER JOIN fee_cutting_records as bb ON bb.user_id = aa.user_id WHERE (aa.year = #{year} and bb.year = #{year} and aa.month = #{month} and bb.month = #{month}) GROUP BY aa.user_id"
    BasicSalaryRecord.find_by_sql(sql)
  end

  #get college benefit data by year/month
  def self.get_benefit_data(year, month)
    reg = "cc.life_be + cc.diff_be + cc.livesa_be + cc.tv_be + cc.beaulty_be + cc.other_be"
    sql = "SELECT cc.user_id, (#{reg}) benefit FROM college_be_records as cc WHERE (cc.year = #{year} and cc.month = #{month})"
    CollegeBeRecord.find_by_sql(sql)
  end

end
