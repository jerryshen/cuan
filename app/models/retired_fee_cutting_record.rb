class RetiredFeeCuttingRecord < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id, :year, :month
  validates_numericality_of [:other_fee1, :other_fee2, :other_fee3], :allow_nil => true

  #generate retired fee cuttings for all retired users currently
  def self.generate_retired_fee_cutting(stds)
    stds.each do |fee|
      RetiredFeeCuttingRecord(
        :year => Time.now.year.to_s,
        :month => Time.now.month.to_i.to_s,
        :user_id => fee.user_id,
        :elc_fee => fee.elc_fee,
        :other_fee1 => fee.other_fee1,
        :other_fee2 => fee.other_fee2,
        :other_fee3 => fee.other_fee3)
    end
  end
end
