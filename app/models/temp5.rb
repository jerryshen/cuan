class Temp5 < ActiveRecord::Base

  #data about basic salary and fee cutting 财政在职人员工资
  #import by year and month
  def import(year, month)
    if Temp5.find_by_year_and_month(year, month).blank?
      return "无数据"
    else
      conditions = ["year =? AND month =?", year, month]
      salary = BasicSalaryRecord,find(:all, :conditions => conditions)
      fee_cutting = FeeCuttingRecord.find(:all, :conditions => conditions)
      exsit = salary || fee_cutting
      if exsit
        return "已存在该年月数据！"
      else
        data = Temp5.find(:all, :conditions => conditions)
        data.each do |d|
          user_id = User.find(:first, :conditions => ["name =? AND is_retired =? AND is_nature =?",d.f1,false,true]).id
          BasicSalaryRecord.create(
            :user_id     => user_id,
            :year        => year,
            :month       => month,
            :station_sa  => d.f2,
            :position_sa => d.f3,
            :station_be  => d.f4,
            :foreign_be  => d.f5,
            :region_be   => d.f6,
            :add_sa      => d.f7)
          FeeCuttingRecord.create(
            :user_id     => user_id,
            :year        => year,
            :month       => month,
            :room_fee    => d.f8,
            :med_fee     => d.f9,
            :job_fee     => d.f10,
            :other_fee1  => d.f11,
            :other_fee2  => d.f12,
            :other_fee3  => d.f13)
        end
      end
    end
  end
end
