class TotalStat
  #get total stat by year, month, department
  def self.get_counting(search_year, search_month, department_id)
    if department_id.blank?
      departments = Department.all
      departments.each do |d|
        name  = d.name

        condition = "aa.user_id in (SELECT id FROM users WHERE department_id = #{d.id})  AND"
        if name != "离退休"
          reg = ""
          reg << "aa.station_sa + aa.position_sa + aa.station_be + aa.foreign_be + aa.region_be + aa.hard_be + aa.stay_be"
          reg << " - bb.room_fee - bb.med_fee - bb.elc_fee - bb.net_fee - bb.job_fee - bb.selfedu_fee - bb.other_fee1 - bb.other_fee2 - bb.other_fee3 - bb.self_tax"
          reg << " + cc.life_be + cc.diff_be + cc.livesa_be + cc.tv_be + cc.beaulty_be + cc.other_be"
        
          sql = ""
          sql << "SELECT aa.year year, aa.month month, aa.user_id user_id, #{reg} counting FROM basic_salary_records as aa"
          sql << " INNER JOIN fee_cutting_records as bb INNER JOIN college_be_records as cc"
          sql << " ON aa.user_id = bb.user_id = cc.user_id"
          sql << " WHERE (#{condition} aa.year =#{search_year} AND bb.year =#{search_year} AND cc.year =#{search_year}  AND aa.month =#{search_month} AND bb.month =#{search_month} AND cc.month =#{search_month})"
          sql << " ORDER BY aa.user_id"
          data = BasicSalaryRecord.find_by_sql(sql)
          unless data.blank?
            total = 0
            data.each do |d|
              total += d.counting.to_f
              year   = d.year
              month  = d.month
            end
            nums  = data.count
            avg   = (total / nums).round(2)
            top   = data.sort_by {|t| t.counting}.sort.reverse.first
            bot   = data.sort_by {|t| t.counting}.sort.reverse.last
          end
        else
          reg = ""
          reg << "aa.basic_fee + aa.stay_be + aa.foreign_be + aa.region_be - bb.other_fee1 - bb.other_fee2 - bb.other_fee3"
          reg << " + cc.diff_be + cc.tv_be + cc.beaulty_be + cc.other_be1 + cc.other_be2 + cc.other_be3"
          sql = ""
          sql << "SELECT aa.year year, aa.month month, aa.user_id user_id, (#{reg}) counting FROM retired_basic_salary_records as aa"
          sql << " INNER JOIN retired_fee_cutting_records as bb INNER JOIN retired_college_be_records as cc"
          sql << " ON aa.user_id = bb.user_id = cc.user_id "
          sql << " WHERE (#{condition} aa.year = bb.year = cc.year "
          sql << " AND aa.month = bb.month =  cc.month)"
          sql << " ORDER BY aa.user_id"
          data = RetiredBasicSalaryRecord.find_by_sql(sql)
          unless data.blank?
            total = 0
            data.each do |d|
              total += d.counting.to_f
              year   = d.year
              month  = d.month
            end
            nums = data.count
            avg = (total / nums).round(2)
            top = data.sort_by {|t| t.counting}.sort.reverse.first
            bot = data.sort_by {|t| t.counting}.sort.reverse.last
          end
        end
        hash  = {"department" => name,
          "year"       => year,
          "month"      => month,
          "numbers"    => nums,
          "avg"        => avg,
          "top_name"   => User.find(top.user_id).name,
          "top_salary" => top.counting,
          "bot_name"   => User.find(bot.user_id).name,
          "bot_salary" => bot.counting}
        return hash
      end
    end
  end
end
