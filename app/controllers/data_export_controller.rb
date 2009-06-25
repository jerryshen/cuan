class DataExportController < ApplicationController

  def index
  end

  def export
    year = params[:search_year]
    month = params[:search_month]
    #array for salry data collection
    @salary_data = DataExport.get_salary_data(year, month)
    @salary_data.each do |salary|
      #User.find(salary.user_id).name to get user name
      salary.user_id
      #total
      salary.salary
    end

    #array for benefit data collection
    @benefit_data = DataExport.get_benefit_data(year, month)
    @benefit_data.each do |benefit|
      #User.find(benefit.user_id).name to get user name
      benefit.user_id
      #total
      benefit.benefit
    end
  end
end
