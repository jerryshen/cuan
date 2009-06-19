module PerformanceBenefitStdsHelper
  #select options for index searching
  def list_titles_for_search
    @options = [["所有",""]]
    Title.find_by_sql("select id,name from titles").each do |row|
      ar=[]
      ar << row.attributes["name"].to_s
      ar << row.attributes["id"].to_s
      @options << ar
    end
  end

  def list_positions_for_search
    @options = [["所有",""]]
      Position.find_by_sql("select id,name from positions").each do |row|
      ar=[]
      ar << row.attributes["name"].to_s
      ar << row.attributes["id"].to_s
      @options << ar
    end
  end
end
