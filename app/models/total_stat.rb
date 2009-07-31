class TotalStat

  #get total stat of whole college
  def self.stat
    data = SalaryDetail.view_inc_salaries
    total = []

    departments = Department.all.reject{|x| x.name == "离退休"}
    departments.each do |dep|

      # 财政支出 3621186
      finances = data.select{|x| x["dep_id"] == dep.id && User.find(x["user_id"]).is_nature == true}
      fin_total = 0
      fin_salary_list = []
      finances.each do |d|
        salary  = d["s1"].to_f + d["s2"].to_f + d["s3"].to_f + d["s4"].to_f + d["s5"].to_f + d["s6"].to_f + d["s7"].to_f
        fee_cut = d["f1"].to_f + d["f2"].to_f + d["f3"].to_f + d["f4"].to_f + d["f5"].to_f + d["f6"].to_f + d["f7"].to_f + d["f8"].to_f + d["f9"].to_f + d["f10"].to_f
        benefit = d["b1"].to_f + d["b2"].to_f + d["b3"].to_f + d["b4"].to_f + d["b5"].to_f + d["b6"].to_f
        eve_total   = salary - fee_cut + benefit
        fin_total += eve_total
        fin_salary_list.push({"year" => d["year"], "month" => d["month"], "user_id" => d["user_id"], "total" => eve_total})
      end
      top_finance = fin_salary_list.sort_by{|x| x["total"]}.last
      bot_finance = fin_salary_list.sort_by{|x| x["total"]}.first

      #学院支出
      colleges = data.select{|x| x["dep_id" == dep.id && User.find(x["user_id"]).is_nature == false]}
      col_salary_list = []
      colleges.each do |d|
        salary  = d["s1"].to_f + d["s2"].to_f + d["s3"].to_f + d["s4"].to_f + d["s5"].to_f + d["s6"].to_f + d["s7"].to_f
        fee_cut = d["f1"].to_f + d["f2"].to_f + d["f3"].to_f + d["f4"].to_f + d["f5"].to_f + d["f6"].to_f + d["f7"].to_f + d["f8"].to_f + d["f9"].to_f + d["f10"].to_f
        benefit = d["b1"].to_f + d["b2"].to_f + d["b3"].to_f + d["b4"].to_f + d["b5"].to_f + d["b6"].to_f
        eve_total   = salary - fee_cut + benefit
        col_salary_list.push({"year" => d["year"], "month" => d["month"],"user_id" => d["user_id"], "total" => eve_total})
      end
      top_college = col_salary_list.sort_by{|x| x["total"]}.last
      bot_college = col_salary_list.sort_by{|x| x["total"]}.first


      total.push({"dep_id" => dep.id,})

    end
  end


  def self.get_inc_stat
    inc_deps = Department.all.reject{|x| x.name == "离退休"}
    inc_deps.each do |dep|
      sql_condition = "aa.user_id in (SELECT id FROM users WHERE department_id = #{dep.id} AND"

      reg = ""
      reg << "aa.station_sa + aa.position_sa + aa.station_be + aa.foreign_be + aa.region_be + aa.hard_be + aa.stay_be"
      reg << " - bb.room_fee - bb.med_fee - bb.elc_fee - bb.net_fee - bb.job_fee - bb.selfedu_fee - bb.other_fee1 - bb.other_fee2 - bb.other_fee3 - bb.self_tax"
      reg << " + cc.life_be + cc.diff_be + cc.livesa_be + cc.tv_be + cc.beaulty_be + cc.other_be"

      select = ""
      select << "aa.year year, aa.month month, aa.user_id user_id, #{reg} eve_total"

      sql = ""
      sql << "SELECT #{select} FROM basic_salary_records as aa"
      sql << " INNER JOIN fee_cutting_records as bb INNER JOIN college_be_records as cc"
      sql << " ON aa.user_id = bb.user_id = cc.user_id"
      sql << " WHERE (#{sql_condition} aa.year = bb.year AND aa.year = cc.year AND aa.month = bb.month AND aa.month = cc.month)"

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
  end























  def self.test
    arr = []
    arr << {"date" => 200906, "user_id" => 1, "total" => 2000}
    arr << {"date" => 200906, "user_id" => 2, "total" => 2000}
    arr << {"date" => 200906, "user_id" => 3, "total" => 2000}
    arr << {"date" => 200906, "user_id" => 4, "total" => 2000}
    arr << {"date" => 200906, "user_id" => 5, "total" => 2000}
    arr << {"date" => 200906, "user_id" => 6, "total" => 2000}
    arr << {"date" => 200906, "user_id" => 1, "total" => 2000}
    arr << {"date" => 200907, "user_id" => 2, "total" => 2000}
    arr << {"date" => 200907, "user_id" => 3, "total" => 2000}
    arr << {"date" => 200907, "user_id" => 4, "total" => 2000}
    arr << {"date" => 200907, "user_id" => 5, "total" => 2000}
    arr << {"date" => 200907, "user_id" => 6, "total" => 2000}
    return arr
  end
end





















