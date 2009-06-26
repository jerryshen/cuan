class DataExportController < ApplicationController

  def index
  end

  def export
    year = params[:search_year]
    month = params[:search_month]
    #salry data collection
    @salary_data = DataExport.get_salary_data(year, month)
    @salary_data.each do |salary|
      #User.find(salary.user_id).name to get user name
      salary.user_id
      #total
      salary.salary
    end

    #benefit data collection
    @benefit_data = DataExport.get_benefit_data(year, month)
    @benefit_data.each do |benefit|
      #User.find(benefit.user_id).name to get user name
      benefit.user_id
      #total
      benefit.benefit
    end

    #retired salary data collection
    @retired_salary_data = DataExport.get_retired_salary_data(year, month)
    @retired_salary_data.each do |salary|
      salary.user_id
      salary.retired_salary
    end

    #retired benefit data collection
    @retired_benefit_data = DataExport.get_retired_benefit_data(year, month)
    @retired_benefit_data.each do |benefit|
      benefit.user_id
      benefit.retired_benefit
    end
  end

end