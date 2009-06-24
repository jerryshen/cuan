class DataExport

  def self.get_salary_data(year, month)
    BasicSalaryRecord.find(:all, :conditions => ["year = ? and month = ?", year, month])
  end

  def self.get_fee_cutting_data(year, month)
    FeeCuttingRecord.find(:all, :conditions => ["year = ? and month = ?", year, month])
  end

  def self.get_benefit_data(year, month)
    CollegeBeRecord.find(:all, :conditions => ["year = ? and month = ?", year, month])
  end

end
