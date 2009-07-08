class Temp3 < ActiveRecord::Base

  #data about retired basic salary and retired fee cutting 退休人员工资
  #date import by year and month
  def import(year, month)
    if Temp3.find_by_year_and_month(year, month).blank?
      return "无数据"
    else
      conditions = ["year =? AND month =?",year, month]
      salary = RetiredBasicSalaryRecord.find(:all, :conditions => conditions)
      fee_cutting = RetiredFeeCutting.find(:all, :conditions => conditions)
      exsit = salary || fee_cutting
      if exsit
        return "已存在该年月数据！"
      else
        data = Temp3.find(:all, :conditions => conditions)
        data.each do |d|
          user_id = User.find(:first, :conditions => ["name =? AND is_retired =?",d.f1,true]).id
          RetiredBasicSalaryRecord.create(
            :user_id    => user_id,
            :year       => year,
            :month      => month,
            :basic_fee  => d.f2,
            :stay_be    => d.f3,
            :foreign_be => d.f4,
            :region_be  => d.f5)
          RetiredFeeCuttingRecord.create(
            :user_id    => user_id,
            :year       => year,
            :month      => month,
            :elc_fee    => d.f6,
            :other_fee2 => d.f7,
            :other_fee3 => d.f8) #other fee1 null
        end
      end
    end
  end
end
