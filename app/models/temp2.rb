class Temp2 < ActiveRecord::Base

  #data about basic salary and fee cutting 在职员工学院工资（在职非入编员工）
  #date import by year and month
  def import(year, month)
    if Temp2.find_by_year_and_month(year, month).blank?
      return "无数据"
    else
      conditions = ["year =? AND month =?", year, month]
      salary = BasicSalaryRecord.find(:all, :conditions => conditions)
      fee_cutting = FeeCuttingRecord.find(:all, :conditions => conditions)
      benefit = CollegeBeRecord.find(:all, :conditions => conditions)
      exsit = salary || fee_cutting || benefit
      if exsit
        return "已存在当前年月数据！"
      else
        data = Temp2.find(:all, :conditions => conditions)
        data.each do |d|
          user_id = User.find(:first, :conditions => ["name =? AND is_retired =? AND is_nature =?",d.f1,false,false]).id
          BasicSalaryRecord.create(
            :user_id      => user_id,
            :year         => year,
            :month        => month,
            :station_sa   => d.f3,
            :position_sa  => d.f4,
            :hard_be      => d.f5,
            :stay_be      => d.f6,
            :foreign_be   => d.f7,
            :region_be    => d.f8,
            :add_sa       => d.f10)  #station_be null
          CollegeBeRecord.create(
            :user_id      => user_id,
            :year         => year,
            :month        => month,
            :life_be      => d.f11,
            :diff_be      => d.f12,
            :livesa_be    => d.f13,
            :tv_be        => d.f14,
            :beaulty_be   => d.f15,
            :other_be     => d.f17) #f16应发工资
          FeeCuttingRecord.create(
            :user_id => user_id,
            :year => year,
            :month => month,
            :room_fee => d.f18,
            :med_fee  => d.f19,
            :selfedu_fee => d.f20,
            :self_tax => d.f21,
            :elc_fee => d.f22,
            :job_fee => d.f23,
            :other_fee1 => d.f24,
            :other_fee2 => d.f25,
            :other_fee3 => d.f26) #net_fee null
        end
      end
    end
  end

end
