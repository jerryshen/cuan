class User < ActiveRecord::Base
  #mapping
  belongs_to :department, :class_name => 'Department', :foreign_key => 'department_id'
  belongs_to :td_belongs, :class_name => 'Department', :foreign_key => 'department_id'
  belongs_to :title, :class_name => 'Title', :foreign_key =>'title_id'
  belongs_to :position, :class_name => 'Position', :foreign_key => 'position_id'

  has_many :role_users
  has_many :roles, :through => :role_users, :class_name => 'Role', :foreign_key => 'role_id'

  has_many :bank_cards

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
        menu_modules << MenuModule.new(m, pages.collect{|p| p if(p.page_module == m && !p.hidden)}.compact! ) 
      end
    end
    menu_modules.sort!{|x,y| x.index <=> y.index}
    menu_modules.to_json
  end
end
