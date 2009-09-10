class RetiredBasicSalaryRecord < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id, :year, :month
  validates_numericality_of :basic_fee
  validates_numericality_of [:stay_be, :foreign_be, :region_be],
    :allow_nil => true

  #generate retired basic salary records for all retired users currently
  def self.generate_retired_salaries(stds)
    stds.each do |s|
      RetiredBasicSalaryRecord.create(
        :year => Time.now.year.to_s,
        :month => Time.now.month.to_i.to_s,
        :user_id => s.user_id,
        :basic_fee => s.basic_fee,
        :stay_be => s.stay_be,
        :foreign_be => s.foreign_be,
        :region_be => s.region_be)
    end
  end

end
