class FeeCuttingRecord < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id, :year, :month
  validates_numericality_of [:room_fee, :med_fee, :elc_fee, :net_fee, :job_fee,
    :selfedu_fee, :other_fee1, :other_fee2, :other_fee3],
    :allow_nil => true

  #generate fee cuttings for all users currently
  def self.generate_fee_cutting(stds)
    stds.each do |f|
      FeeCuttingRecord.create(
        :year => Time.now.year.to_s,
        :month => Time.now.month.to_i.to_s,
        :user_id => f.user_id,
        :room_fee => f.room_fee,
        :med_fee => f.med_fee,
        :elc_fee => f.elc_fee,
        :job_fee => f.job_fee,
        :selfedu_fee => f.selfedu_fee,
        :net_fee => f.net_fee,
        :other_fee1 => f.other_fee1,
        :other_fee2 => f.other_fee2,
        :other_fee3 => f.other_fee3,
        :self_tax => f.self.tax)
    end
  end
end
