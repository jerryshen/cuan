class UndefindFee < ActiveRecord::Base
  #mapping
  belongs_to :user

  #validations
  validates_presence_of :user_id
  validates_numericality_of :fee


  #multi deliver undefined fees
  def self.deliver(department_id, title_id, subject, fee)
    conditions = ""
    values = []
    if(!department_id.blank?)
      conditions += "department_id = ? "
      values << department_id
    end

    if(!title_id.blank?)
      conditions += " AND title_id = ? "
      values << title_id
    end

    if(!conditions.blank?)
      option_conditions = [conditions,values].flatten!
      users = User.find(:all, :conditions => option_conditions)
    else
      users = User.all
    end

    users.each do |u|
      UndefindFee.create(
        :user_id => u.id,
        :subject => subject,
        :fee     => fee,
        :date    => Time.now
      )
    end
    return true
  end

end
