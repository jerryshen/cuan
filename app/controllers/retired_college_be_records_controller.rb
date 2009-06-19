class RetiredCollegeBeRecordsController < ApplicationController
  # GET /retired_college_be_records
  # GET /retired_college_be_records.xml
  def index
    @retired_college_be_records = RetiredCollegeBeRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @retired_college_be_records }
      format.json { render :text => get_json }
    end
  end

  # GET /retired_college_be_records/1
  # GET /retired_college_be_records/1.xml
  def show
    @retired_college_be_record = RetiredCollegeBeRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @retired_college_be_record }
    end
  end

  # GET /retired_college_be_records/new
  # GET /retired_college_be_records/new.xml
  def new
    @retired_college_be_record = RetiredCollegeBeRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @retired_college_be_record }
    end
  end

  # GET /retired_college_be_records/1/edit
  def edit
    @retired_college_be_record = RetiredCollegeBeRecord.find(params[:id])
  end

  # POST /retired_college_be_records
  # POST /retired_college_be_records.xml
  def create
    @retired_college_be_record = RetiredCollegeBeRecord.new(params[:retired_college_benefit_record])

    respond_to do |format|
      if @retired_college_be_record.save
        #        flash[:notice] = 'RetiredCollegeBenefit was successfully created.'
        format.html { redirect_to(@retired_college_be_record) }
        format.xml  { render :xml => @retired_college_be_record, :status => :created, :location => @retired_college_be_record }
        format.json { render :text => '{status: "success", message: "成功创建离退休人员学院补贴记录！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @retired_college_be_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@retired_college_be_record.errors.to_json}}"}
      end
    end
  end

  # PUT /retired_college_be_records/1
  # PUT /retired_college_be_records/1.xml
  def update
    @retired_college_be_record = RetiredCollegeBeRecord.find(params[:id])

    respond_to do |format|
      if @retired_college_be_record.update_attributes(params[:retired_college_benefit_record])
        #        flash[:notice] = 'RetiredCollegeBenefit was successfully updated.'
        format.html { redirect_to(@retired_college_be_record) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改离退休人员学院补贴记录！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @retired_college_be_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@retired_college_be_record.errors.to_json}}"}
      end
    end
  end

  # DELETE /retired_college_be_records/1
  # DELETE /retired_college_be_records/1.xml
  def destroy
    @retired_college_be_record = RetiredCollegeBeRecord.find(params[:id])
    @retired_college_be_record.destroy

    respond_to do |format|
      format.html { redirect_to(retired_college_be_records_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  private
  def get_json
    pagesize = 10
    if(params[:page_size])
      param_pagesize = params[:page_size].to_i
      if param_pagesize > 0 then pagesize = param_pagesize end
    end
    
    conditions = '1=1'
    condition_values = []
    if(!params[:search_name].blank?)
      if user = User.find_by_name(params[:search_name])
        user_id = user.id
      else
        user_id = 0
      end
      joins = ""
      conditions += " AND user_id = ?"
      condition_values << user_id
    end

    if(!params[:search_year].blank?)
      joins = ""
      conditions += " AND year = ?"
      condition_values << params[:search_year]
    end

    if(!params[:search_month].blank?)
      joins = ""
      conditions += " AND month = ?"
      condition_values << params[:search_month]
    end

    if(!params[:search_department_id].blank?)
      joins = "INNER JOIN users p ON retired_college_be_records.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @retired_college_be_records = RetiredCollegeBeRecord.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=>pagesize, :page => params[:page] || 1)
      count = RetiredCollegeBeRecord.count(:joins => joins, :conditions => option_conditions)
    else
      @retired_college_be_records = RetiredCollegeBeRecord.paginate(:order =>"id DESC",:per_page=>pagesize, :page => params[:page] || 1)
      count = RetiredCollegeBeRecord.count
    end
    return render_json(@retired_college_be_records,count)
  end
end
