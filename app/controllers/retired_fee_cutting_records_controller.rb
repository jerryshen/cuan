class RetiredFeeCuttingRecordsController < ApplicationController
  # GET /retired_fee_cutting_records
  # GET /retired_fee_cutting_records.xml
  def index
    @retired_fee_cutting_records = RetiredFeeCuttingRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @retired_fee_cutting_records }
      format.json { render :text => get_json }
    end
  end

  # GET /retired_fee_cutting_records/1
  # GET /retired_fee_cutting_records/1.xml
  def show
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @retired_fee_cutting_record }
    end
  end
  # GET /retired_fee_cutting_records/new
  # GET /retired_fee_cutting_records/new.xml
  def new
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @retired_fee_cutting_record }
    end
  end

  # GET /retired_fee_cutting_records/1/edit
  def edit
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.find(params[:id])
  end

  # POST /retired_fee_cutting_records
  # POST /retired_fee_cutting_records.xml
  def create
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.new(params[:retired_fee_cutting_record])

    respond_to do |format|
      if @retired_fee_cutting_record.save
        #        flash[:notice] = 'RetiredFeeCutting was successfully created.'
        format.html { redirect_to(@retired_fee_cutting_record) }
        format.xml  { render :xml => @retired_fee_cutting_record, :status => :created, :location => @retired_fee_cutting_record }
        format.json { render :text => '{status: "success", message: "成功添加离退休人员扣款！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @retired_fee_cutting_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@retired_fee_cutting_record.errors.to_json}}"}
      end
    end
  end

  # PUT /retired_fee_cutting_records/1
  # PUT /retired_fee_cutting_records/1.xml
  def update
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.find(params[:id])

    respond_to do |format|
      if @retired_fee_cutting_record.update_attributes(params[:retired_fee_cutting_record])
        #        flash[:notice] = 'RetiredFeeCutting was successfully updated.'
        format.html { redirect_to(@retired_fee_cutting_record) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新离退休人员扣款！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @retired_fee_cutting_record.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@retired_fee_cutting_record.errors.to_json}}"}
      end
    end
  end
  # DELETE /retired_fee_cutting_records/1
  # DELETE /retired_fee_cutting_records/1.xml
  def destroy
    @retired_fee_cutting_record = RetiredFeeCuttingRecord.find(params[:id])
    @retired_fee_cutting_record.destroy

    respond_to do |format|
      format.html { redirect_to(retired_fee_cutting_records_url) }
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
    if(!params[:search_name].blank? && params[:search_department_id].blank?)
      if user = User.find_by_name(params[:search_name])
        user_id = user.id
      else
        user_id = 0
      end
      @retired_fee_cutting_records = RetiredFeeCuttingRecord.paginate(:order =>"id DESC", :conditions => ["user_id =?",user_id],:per_page=>pagesize, :page => params[:page] || 1)
      count = @retired_fee_cutting_records.length
    elsif(!params[:search_department_id].blank? && params[:search_name].blank?)
      @fee_cuttings = RetiredFeeCuttingRecord.paginate(:order => "id DESC", :joins =>"INNER JOIN users p ON retired_fee_cutting_records.user_id=p.id" , :conditions =>["p.department_id =?",params[:search_department_id]],:per_page=>pagesize, :page => params[:page] || 1 )
      count = @retired_fee_cutting_records.length
    elsif(!params[:search_department_id].blank? && !params[:search_name].blank?)
      @retired_fee_cutting_records = RetiredFeeCuttingRecord.paginate(:order => "id DESC", :joins =>"INNER JOIN users p ON retired_fee_cutting_records.user_id=p.id" , :conditions =>["p.department_id =? and p.name like ?",params[:search_department_id],"%#{params[:search_name]}%"],:per_page=>pagesize, :page => params[:page] || 1 )
      count = @retired_fee_cutting_records.length
    else
      @retired_fee_cutting_records = RetiredFeeCuttingRecord.paginate(:order =>"id DESC",:per_page=>pagesize, :page => params[:page] || 1)
      count = RetiredFeeCuttingRecord.count
    end
    return render_json(@retired_fee_cutting_records,count)
  end
end
