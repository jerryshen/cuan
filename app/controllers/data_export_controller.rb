class DataExportController < ApplicationController

  def index
  end

  # department, name, card number, salary/benefit  excel/csv
  def export
    year = params[:search_year]
    month = params[:search_month]
    joins = "INNER JOIN banks b ON bank_cards.bank_id=b.id"
    #salary data collection
    @salary_data = DataExport.get_salary_data(year, month)
    @salary_data.each do |salary|
      User.find(salary.user_id).department.name
      User.find(salary.user_id).name
      BankCard.find(:first,:joins => joins, :conditions => ["user_id =? AND b.name=?",salary.user_id, "工商银行"]).card_number
      #total
      salary.salary
    end

    #benefit data collection
    @benefit_data = DataExport.get_benefit_data(year, month)
    @benefit_data.each do |benefit|
      User.find(benefit.user_id).department.name
      User.find(benefit.user_id).name
      BankCard.find(:first, :joins => joins, :conditions => ["user_id =? AND b.name=?",benefit.user_id, "邮政"]).card_number
      #total
      benefit.benefit
    end

    #retired salary data collection
    @retired_salary_data = DataExport.get_retired_salary_data(year, month)
    @retired_salary_data.each do |salary|
      User.find(salary.user_id).department.name
      User.find(salary.user_id).name
      BankCard.find(:first, :joins => joins, :conditions => ["user_id=? AND b.name=?", salary.user_id, "工商银行"]).card_number
      salary.retired_salary
    end

    #retired benefit data collection
    @retired_benefit_data = DataExport.get_retired_benefit_data(year, month)
    @retired_benefit_data.each do |benefit|
      User.find(benefit.user_id).department.name
      User.find(benefit.user_id).name
      BankCard.find(:first, :joins => joins, :conditions => ["user_id=? AND b.name=?", benefit.user_id, "邮政"]).card_number
      benefit.retired_benefit
    end
  end
end