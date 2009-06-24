class DataExportController < ApplicationController

  def index
    year = params[:search_year]
    month = params[:search_month]
    @salary_data = DataExport.get_salary_data(year, month)
    @fee_cutting_data = DataExport.get_fee_cutting_data(year, month)
    @benefit_data = DataExport.get_benefit_data(year, month)

    @salary_data.each do |s|
      s.user.name
      s.total = s.station_sa + s.position_sa + s.station_be + s.foreign_be + s.region_be + s.hard_be + s.stay_be
      @fee_cutting_data.each do |f|
        f.user.name
        f.total = f.room_fee + f.med_fee + f.elc_fee + f.net_fee + f.job_fee + f.selfedu_fee + f.other_fee1 + f.other_fee2 +
          f.other_fee3 + f.self_tax
        if f.user.name == s.user.name
          f.salary_gain = s.total - f.total
        end
      end
    end

  end

end
