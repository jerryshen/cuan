class BasicSalaryRecord < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id, :year, :month
  validates_numericality_of :station_sa, :position_sa
  validates_numericality_of [:station_be, :foreign_be, :region_be, :hard_be, :stay_be],
    :allow_nil => true


  #generate salaries for all users current year and month.
  def self.generate_basic_salaries(stds)
    stds.each do |s|
      BasicSalaryRecord.create(
        :year  => Time.now.year.to_s,
        :month => Time.now.month.to_i.to_s,
        :user_id => s.user_id,
        :station_sa => s.station_sa,
        :position_sa => s.position_sa,
        :station_be => s.station_be,
        :foreign_be => s.foreign_be,
        :region_be => s.region_be,
        :hard_be => s.hard_be,
        :stay_be => s.stay_be)
    end
  end

end
