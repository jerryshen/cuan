class Profile

  # view self salary detail about basic salary, fee cutting, benefit. etc.
  def self.view_salary(user_id, retired)
    total = []
    dep_id = User.find(user_id).department.id
    case retired
    when false
      select = ""
      select << "aa.year year, aa.month month,"
      select << "aa.station_sa s1, aa.position_sa s2, aa.station_be s3, aa.foreign_be s4, aa.region_be s5,"
      select << "aa.hard_be s6, aa.stay_be s7, bb.room_fee f1, bb.med_fee f2, bb.elc_fee f3, bb.net_fee f4, bb.job_fee f5,"
      select << "bb.selfedu_fee f6, bb.other_fee1 f7, bb.other_fee2 f8, bb.other_fee3 f9, bb.self_tax f10,"
      select << "cc.life_be b1, cc.diff_be b2, cc.livesa_be b3, cc.tv_be b4, cc.beaulty_be b5, cc.other_be b6"

      sql = ""
      sql << "SELECT #{select} FROM basic_salary_records as aa"
      sql << " INNER JOIN fee_cutting_records as bb INNER JOIN college_be_records as cc"
      sql << " ON aa.user_id = bb.user_id AND aa.user_id = cc.user_id"
      sql << " WHERE (aa.user_id = #{user_id} AND aa.year = bb.year AND aa.year = cc.year AND aa.month = bb.month AND aa.month = cc.month)"
      sql << " ORDER BY aa.year"
      data = BasicSalaryRecord.find_by_sql(sql)
      if data.length == 1
        basic   = data.s1.to_f + data.s2.to_f + data.s3.to_f + data.s4.to_f + data.s5.to_f + data.s6.to_f + data.s7.to_f
        fee_cut = data.f1.to_f + data.f2.to_f + data.f3.to_f + data.f4.to_f + data.f5.to_f + data.f6.to_f + data.f7.to_f + data.f8.to_f + data.f9.to_f
        benefit = data.b1.to_f + data.b2.to_f + data.b3.to_f + data.b4.to_f + data.b5.to_f + data.b6.to_f
        total << {"dep_id" => dep_id ,"user_id" => user_id, "year"  => data.year, "month" => data.month, "s1"    => data.s1,  "s2"    => data.s2,
          "s3"    => data.s3,   "s4"    => data.s4,    "s5"    => data.s5,  "s6"    => data.s6,
          "s7"    => data.s7,   "f1"    => data.f1,    "f2"    => data.f2,  "f3"    => data.f3,
          "f4"    => data.f4,   "f5"    => data.f5,    "f6"    => data.f6,  "f7"    => data.f7,
          "f8"    => data.f8,   "f9"    => data.f9,    "f10"   => data.f10, "b1"    => data.b1,  "b2"    => data.b2,
          "b3"    => data.b3,   "b4"    => data.b4,    "b5"    => data.b5,  "b6"    => data.b6,
          "basic" => basic,   "fee_cut" => fee_cut,  "benefit" => benefit}
      else
        data.each do |d|
          basic   = d.s1.to_f + d.s2.to_f + d.s3.to_f + d.s4.to_f + d.s5.to_f + d.s6.to_f + d.s7.to_f
          fee_cut = d.f1.to_f + d.f2.to_f + d.f3.to_f + d.f4.to_f + d.f5.to_f + d.f6.to_f + d.f7.to_f + d.f8.to_f + d.f9.to_f
          benefit = d.b1.to_f + d.b2.to_f + d.b3.to_f + d.b4.to_f + d.b5.to_f + d.b6.to_f
          total.push({"dep_id" => dep_id ,"user_id" => user_id, "year"  => d.year, "month" => d.month, "s1"    => d.s1,  "s2"    => d.s2,
              "s3"    => d.s3,   "s4"    => d.s4,    "s5"    => d.s5,  "s6"    => d.s6,
              "s7"    => d.s7,   "f1"    => d.f1,    "f2"    => d.f2,  "f3"    => d.f3,
              "f4"    => d.f4,   "f5"    => d.f5,    "f6"    => d.f6,  "f7"    => d.f7,
              "f8"    => d.f8,   "f9"    => d.f9,    "f10"   => d.f10, "b1"    => d.b1,  "b2"    => d.b2,
              "b3"    => d.b3,   "b4"    => d.b4,    "b5"    => d.b5,  "b6"    => d.b6,
              "basic" => basic,   "fee_cut" => fee_cut,  "benefit" => benefit})
        end
      end
      return total
    when true
      select = ""
      select << "aa.year year, aa.month month,"
      select << "aa.basic_fee s1, aa.stay_be s1, aa.foreign_be s3, aa.region_be s4,"
      select << "bb.other_fee1 f1, bb.other_fee2 f2, bb.other_fee3 f3,"
      select << "cc.diff_be b1, cc.tv_be b2, cc.beaulty_be b3, cc.other_be1 b4, cc.other_be2 b5, cc.other_be3 b6"

      sql = ""
      sql << "SELECT #{select} FROM retired_basic_salary_records as aa"
      sql << " INNER JOIN retired_fee_cutting_records as bb INNER JOIN retired_college_be_records as cc"
      sql << " ON aa.user_id = bb.user_id AND aa.user_id = cc.user_id "
      sql << " WHERE (aa.user_id =#{user_id} AND aa.year = bb.year AND aa.year = cc.year"
      sql << " AND aa.month = bb.month AND aa.month = cc.month)"
      sql << " ORDER BY aa.year"
      data = RetiredBasicSalaryRecord.find_by_sql(sql)
      if data.length == 1
        basic   = data.s1.to_f + data.s2.to_f + data.s3.to_f + data.s4.to_f
        fee_cut = data.f1.to_f + data.f2.to_f + data.f3.to_f
        benefit = data.b1.to_f + data.b2.to_f + data.b3.to_f + data.b4.to_f + data.b5.to_f + data.b6.to_f
        total << {"user_id" => user_id, "year"  => data.year, "month" => data.month, "s1"    => data.s1,  "s2"    => data.s2,
          "s3"    => data.s3,   "s4"    => data.s4,    "f1"    => data.f1,  "f2"    => data.f2,
          "f3"    => data.f3,   "b1"    => data.b1,  "b2"    => data.b2,    "b3"    => data.b3,
          "b4"    => data.b4,    "b5"    => data.b5,  "b6"    => data.b6,
          "basic" => basic,   "fee_cut" => fee_cut,  "benefit" => benefit}
      else
        data.each do |d|
          basic   = d.s1.to_f + d.s2.to_f + d.s3.to_f + d.s4.to_f
          fee_cut = d.f1.to_f + d.f2.to_f + d.f3.to_f
          benefit = d.b1.to_f + d.b2.to_f + d.b3.to_f + d.b4.to_f + d.b5.to_f + d.b6.to_f
          total << {"user_id" => user_id, "year"  => d.year, "month" => d.month, "s1"    => d.s1,  "s2"    => d.s2,
            "s3"    => d.s3,   "s4"    => d.s4,  "f1"  => d.f1,  "f2"    => d.f2,
            "f3"    => d.f3,   "b1"    => d.b1,  "b2"  => d.b2,  "b3"    => d.b3,
            "b4"    => d.b4,   "b5"    => d.b5,  "b6"  => d.b6,
            "basic" => basic,   "fee_cut" => fee_cut,  "benefit" => benefit}
        end
        return total
      end
    end
    return total
  end

end
