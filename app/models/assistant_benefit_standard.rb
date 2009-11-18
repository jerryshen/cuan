class AssistantBenefitStandard < ActiveRecord::Base
  belongs_to :assistant

  validates_presence_of :assistant_id, :benefit
  validates_uniqueness_of :assistant_id

    #generate salaries for all users current year and month.
  def self.generate_assistant_benefit(stds)
    stds.each do |s|
      AssistantBenefit.create(
      :assistant_id => s.assistant_id,
      :year         => Time.now.year,
      :month        => Time.now.month,
      :benefit      => s.benefit,
      :other        => s.other,
      :is_verified  => false
    )

    end
  end
  
end
