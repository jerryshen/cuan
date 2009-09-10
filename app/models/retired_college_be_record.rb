class RetiredCollegeBeRecord < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id, :year, :month
  validates_numericality_of [:diff_be, :tv_be, :beaulty_be, :other_be1, :other_be3], :allow_nil => true


  #generate retired college benefit for all retired users currently
  def self.generate_retired_benefits(stds)
    stds.each do |benefit|
      RetiredCollegeBeRecord.create(
        :year => Time.now.year.to_s,
        :month => Time.now.month.to_i.to_s,
        :user_id => benefit.user_id,
        :diff_be => benefit.diff_be,
        :tv_be => benefit.tv_be,
        :beaulty_be => benefit.beaulty_be,
        :other_be1 => benefit.other_be1,
        :other_be2 => benefit.other_be2,
        :other_be3 => benefit.other_be3)
    end
  end
end
