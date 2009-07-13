class Temp5 < ActiveRecord::Base

  #data about basic salary and fee cutting 财政在职人员工资  college benefit all 0
  def self.import_data
    data = Temp5.all
    if data
      data.each do |d|
        user_id = User.find(:first, :conditions => ["name =? AND is_retired =? AND is_nature =?",d.f1,false,true]).id
        BasicSalaryRecord.create(
          :user_id     => user_id,
          :year        => d.year,
          :month       => d.month,
          :station_sa  => d.f2,
          :position_sa => d.f3,
          :station_be  => d.f4,
          :foreign_be  => d.f5,
          :region_be   => d.f6,
          :add_sa      => d.f7)
        FeeCuttingRecord.create(
          :user_id     => user_id,
          :year        => d.year,
          :month       => d.month,
          :room_fee    => d.f8,
          :med_fee     => d.f9,
          :job_fee     => d.f10,
          :other_fee1  => d.f11,
          :other_fee2  => d.f12,
          :other_fee3  => d.f13)
        CollegeBeRecord.create(
          :user_id     => user_id,
          :year        => d.year,
          :month       => d.month)
      end
    else
      return "无数据"
    end
  end

  #import users
  def self.import_users
    data = Temp5.all
    if data
      data.each do |d|
        Temp5.find_by_sql("INSERT INTO 'users' ('name', 'is_retired', 'is_nature') VALUES('#{d.f1}', 'f', 't')")
      end
    end
  end
end
