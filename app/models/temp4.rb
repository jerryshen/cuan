class Temp4 < ActiveRecord::Base

  #data about retired college benefit and retired fee cutting 退休人员学院工资
  #import by year and month
  def import(year, month)
    if Temp4.find_by_year_and_month(year, month)
      return "无数据"
    else
      conditions = ["year =? AND month =?", year, month]
      benefit = RetiredCollegeBeRecord.find(:all, :conditions => conditions)
      fee_cutting = RetiredFeeCuttingRecord.find(:all, :conditions => conditions)
      exsit = benefit || fee_cutting
      if exsit
        return "已存在该边月数据！"
      else
        data = Temp4.find(:all, :conditions => conditions)
        data.each do |d|
          user_id = User.find(:first, :conditions => ["name =? AND is_retired =? AND is_nature =?", d.name,true,false]).id
          RetiredCollegeBeRecord.create(
            :user_id => user_id,
            :year => year,
            :month => month,
            :diff_be => d.f3,
            :tv_be => d.f4,
            :beaulty_be => d.f5,
            :other_be1 => d.f6,
            :other_be2 => d.f7,
            :other_be3 => d.f8
          )
          RetiredFeeCuttingRecord.create(
            :user_id => user_id,
            :year => year,
            :month => month,
            :elc_fee => d.f9,
            :other_fee1 => d.f10,
            :other_fee2 => d.f11,
            :other_fee => d.f12)
        end
      end
    end
  end
end
