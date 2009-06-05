class RetiredBasicSalaryRecordsController < ApplicationController
  # GET /retired_basic_salary_records
  # GET /retired_basic_salary_records.xml
  def index
    @retired_basic_salary_records = RetiredBasicSalaryRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @retired_basic_salary_records }
      format.json { render :text => get_json }
    end
  end

  # GET /retired_basic_salary_records/1
  # GET /retired_basic_salary_records/1.xml
  def show
    @retired_basic_salary_record = RetiredBasicSalaryRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @retired_basic_salary_record }
    end
  end

  # DELETE /retired_basic_salary_records/1
  # DELETE /retired_basic_salary_records/1.xml
  def destroy
    @retired_basic_salary_record = RetiredBasicSalaryRecord.find(params[:id])
    @retired_basic_salary_record.destroy

    respond_to do |format|
      format.html { redirect_to(retired_basic_salary_records_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end
end
