class Temp1 < ActiveRecord::Base

  #data about retired basic salary and retired fee cutting
  #data import by year and month
  def self.import(year, month)
    if Temp1.find_by_year_and_month(year, month).blank?
      return "无数据"
    else
      conditions = ["year = ? AND month = ?", year, month]
      salary = RetiredBasicSalaryRecord.find(:all, :conditions => conditions)
      fee_cutting = RetiredFeeCuttingRecord.find(:all, :conditions => conditions)
      exsit = salary || fee_cutting || benefit
      if exsit
        return "已有当年月数据，导入失败!"
      else
        data = Temp1.find(:all, :conditions => conditions)
        data.each do |d|
          user_id = User.find(:first, :conditions => ["name =? AND is_retired = ?",d.f1, true]).id
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
            :elc_fee    => d.f7)
        end
      end
    end
  end
end
