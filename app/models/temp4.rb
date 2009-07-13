class Temp4 < ActiveRecord::Base

  #data about retired college benefit and retired fee cutting 退休人员学院工资 // all retired basic salary 0
  def self.import_data
    data = Temp4.all
    if data
      data.each do |d|
        user_id = User.find(:first, :conditions => ["name =? AND is_retired =? AND is_nature =?", d.f1,true,false]).id
        RetiredCollegeBeRecord.create(
          :user_id     => user_id,
          :year        => d.year,
          :month       => d.month,
          :diff_be     => d.f3,
          :tv_be       => d.f4,
          :beaulty_be  => d.f5,
          :other_be1   => d.f6,
          :other_be2   => d.f7,
          :other_be3   => d.f8
        )
        RetiredFeeCuttingRecord.create(
          :user_id     => user_id,
          :year        => d.year,
          :month       => d.month,
          :elc_fee     => d.f9,
          :other_fee1  => d.f10,
          :other_fee2  => d.f11,
          :other_fee3   => d.f12)
        RetiredBasicSalaryRecord.create(
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
    data = Temp4.all
    if data
      data.each do |d|
        Temp4.find_by_sql("INSERT INTO 'users' ('name', 'is_retired', 'is_nature') VALUES('#{d.f1}', 't', 'f')")
      end
    end
  end
end
