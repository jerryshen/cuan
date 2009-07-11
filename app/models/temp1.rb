class Temp1 < ActiveRecord::Base

  #data about retired basic salary and retired fee cutting //retired college benefit all 0
  def self.import_data
    data = Temp1.all
    if data
      data.each do |d|
        user_id = User.find(:first, :conditions => ["name =? AND is_retired = ?",d.f1, true]).id
        RetiredBasicSalaryRecord.create(
          :user_id    => user_id,
          :year       => d.year,
          :month      => d.month,
          :basic_fee  => d.f2,
          :stay_be    => d.f3,
          :foreign_be => d.f4,
          :region_be  => d.f5)
        RetiredFeeCuttingRecord.create(
          :user_id    => user_id,
          :year       => d.year,
          :month      => d.month,
          :elc_fee    => d.f7)
        RetiredCollegeBeRecord.create(
          :user_id    => user_id,
          :year       => d.year,
          :month      => d.month)
      end
    else
      return "无数据"
    end
  end

  #import users
  def import_users
    data = Tepm1.all
    if data
      data.each do |d|
        execute "INSERT INTO 'users' ('name', 'is_retired') VALUES('#{d.f1}', 't')"
      end
    end
  end
end
