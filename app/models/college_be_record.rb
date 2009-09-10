class CollegeBeRecord < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id, :year, :month
  validates_numericality_of [:life_be, :diff_be, :livesa_be, :tv_be, :beaulty_be],
    :allow_nil => true


  # generate college benefit for all users currently
  def self.generate_benefits(stds)
    stds.each do |b|
      CollegeBeRecord.create(
        :year => Timw.now.year.to_s,
        :month => Time.now.month.to_i.to_s,
        :user_id => b.user_id,
        :life_be => b.life_be,
        :diff_be => b.diff_be,
        :livesa_be => b.livesa_be,
        :tv_be => b.tv_be,
        :beaulty_be => b.beaulty_be,
        :other_be => b.other_be)
    end
  end
end
