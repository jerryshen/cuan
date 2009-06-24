require 'digest/sha1'
class User < ActiveRecord::Base
  #mapping
  belongs_to :department, :class_name => 'Department', :foreign_key => 'department_id'
  belongs_to :td_belongs, :class_name => 'Department', :foreign_key => 'department_id'
  belongs_to :title, :class_name => 'Title', :foreign_key =>'title_id'
  belongs_to :position, :class_name => 'Position', :foreign_key => 'position_id'

  has_many :role_users
  has_many :roles, :through => :role_users, :class_name => 'Role', :foreign_key => 'role_id'

  has_many :bank_cards
  has_many :class_month_benefit_records
  has_many :basic_salary_records
  has_many :college_be_records
  has_many :fee_cutting_records
  has_many :retired_basic_salary_records
  has_many :retired_college_be_records
  has_many :retired_fee_cutting_records

  #validations
  validates_presence_of :name, :department_id, :td_belongs_id, :gender, :title_id, :position_id, :id_card, :login_id
  validates_length_of :id_card, :is => 18
  validates_length_of :login_id, :within => 6..15

  #会引起update_attributes方法失败
  #validates_presence_of :update_password, :only => 'create'

  before_destroy :dont_destroy_admin
  attr_accessor :update_password

  def before_create
    if !self.update_password.blank?
      self.password = User.encryption_password(self.update_password)
    end
  end

  def before_update
    if !self.update_password.blank?
      self.password =  User.encryption_password(self.update_password)
    end
  end

  def self.login(login_id,password)
    unless login_id.size > 15
      find_by_login_id_and_password(login_id,User.encryption_password(password))
    else
      find_by_id_card_and_password(login_id,User.encryption_password(password))
    end
  end

  def update_theme(theme)
    update_attributes(:theme => theme)
  end

  def dont_destroy_admin
    raise "can't destroy admin" if login_id == "admin"
  end

  def change_password(old_password,new_password)
    if User.login(login_id,old_password)
      return true if update_attributes(:update_password => new_password)
    end
    return false
	end

  #列表中实现ID和name的切换显示
  def self.to_json
    hash = {}
    find_by_sql("select id,name from users").each do |row|
      attrs = row.attributes
      hash[attrs["id"]] = attrs["name"]
    end
    return hash.to_json
  end

  class MenuModule
    attr_accessor :id, :name, :icon, :pages, :index

    class MenuPage
      attr_accessor :id, :name, :url, :icon
      def initialize page
        @id = page.id
        @name = page.name
        @url = page.url
        @icon = page.icon
      end
    end

    def initialize page_module,pages 
      @id = page_module.id
      @name = page_module.name
      @icon = page_module.icon
      @index = page_module.index
      @pages = []
      pages.each{ |p| @pages << MenuPage.new(p) }
    end
  end

  #用户可以访问的页面
  def accessable_pages
    pages = []
    self.roles.each{ |r| pages += r.pages }
    return pages 
  end

  #用户的菜单列表
  def menu 
    pages = self.accessable_pages
    menu_modules = []
    pages.each do | p |
      m = p.page_module
      unless menu_modules.find{ |menu_m| menu_m.id == m.id }
        m_pages = pages.collect{|pg| pg if(pg.page_module_id == m.id && !pg.hidden)}
        m_pages.compact! if m_pages.index(nil)
        menu_modules << MenuModule.new(m,m_pages) 
      end
    end
    menu_modules.sort!{|x,y| x.index <=> y.index}
    menu_modules.to_json
  end

  private
  def self.encryption_password(password)
    Digest::SHA1.hexdigest(password)
  end
end
