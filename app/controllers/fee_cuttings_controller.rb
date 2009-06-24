class FeeCuttingsController < ApplicationController
  #  protect_from_forgery :except => :index
  #  skip_before_filter :verify_authenticity_token
  # GET /fee_cuttings
  # GET /fee_cuttings.xml
  def index
    @fee_cuttings = FeeCutting.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fee_cuttings }
      format.json { render :text => get_json }
      format.csv { export_csv(@fee_cuttings,
          { :id => "id", :user_id => "姓名",
            :room_fee => "住房公积金", :med_fee => "医疗保险", :elc_fee => "水电气费",
            :net_fee => "上网费", :job_fee => "失业保险", :selfedu_fee => "职工个人教育费",
            :other_fee1 => "其他扣款一", :other_fee2 => "其他扣款二", :other_fee3 => "其他扣款三",
            :self_tax => "个人所得税"}, "扣款数据.csv") }
    end
  end

  # GET /fee_cuttings/1
  # GET /fee_cuttings/1.xml
  def show
    @fee_cutting = FeeCutting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fee_cutting }
    end
  end

  # GET /fee_cuttings/new
  # GET /fee_cuttings/new.xml
  def new
    @fee_cutting = FeeCutting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fee_cutting }
    end
  end

  # GET /fee_cuttings/1/edit
  def edit
    @fee_cutting = FeeCutting.find(params[:id])
  end

  # POST /fee_cuttings
  # POST /fee_cuttings.xml
  def create
    @fee_cutting = FeeCutting.new(params[:fee_cutting])

    respond_to do |format|
      if @fee_cutting.save
        format.html { redirect_to(@fee_cutting) }
        format.xml  { render :xml => @fee_cutting, :status => :created, :location => @fee_cutting }
        format.json { render :text => '{status: "success", message: "成功创建扣款！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @fee_cutting.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@fee_cutting.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /fee_cuttings/1
  # PUT /fee_cuttings/1.xml
  def update
    @fee_cutting = FeeCutting.find(params[:id])

    respond_to do |format|
      if @fee_cutting.update_attributes(params[:fee_cutting])
        format.html { redirect_to(@fee_cutting) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新扣款！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fee_cutting.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@fee_cutting.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /fee_cuttings/1
  # DELETE /fee_cuttings/1.xml
  def destroy
    @fee_cutting = FeeCutting.find(params[:id])
    @fee_cutting.destroy

    respond_to do |format|
      format.html { redirect_to(fee_cuttings_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  private
  def get_json
    load_page_data

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

    if(!params[:search_department_id].blank?)
      joins = "INNER JOIN users p ON fee_cuttings.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @fee_cuttings = FeeCutting.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = FeeCutting.count(:joins => joins, :conditions => option_conditions)
    else
      @fee_cuttings = FeeCutting.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = FeeCutting.count
    end
    return render_json(@fee_cuttings,count)
  end
end
