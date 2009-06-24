class RetiredFeeCuttingsController < ApplicationController
  # GET /retired_fee_cuttings
  # GET /retired_fee_cuttings.xml
  def index
    @retired_fee_cuttings = RetiredFeeCutting.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @retired_fee_cuttings }
      format.json { render :text => get_json }
      format.csv { export_csv(@retired_fee_cuttings,
          { :id => "id", :user_id => "姓名",
            :other_fee1 => "其他扣款1", :other_fee2 => "其他扣款2", :other_fee3 => "其他扣款3" }, "离退休人员扣款数据.csv") }
    end
  end

  # GET /retired_fee_cuttings/1
  # GET /retired_fee_cuttings/1.xml
  def show
    @retired_fee_cutting = RetiredFeeCutting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @retired_fee_cutting }
    end
  end

  # GET /retired_fee_cuttings/new
  # GET /retired_fee_cuttings/new.xml
  def new
    @retired_fee_cutting = RetiredFeeCutting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @retired_fee_cutting }
    end
  end

  # GET /retired_fee_cuttings/1/edit
  def edit
    @retired_fee_cutting = RetiredFeeCutting.find(params[:id])
  end

  # POST /retired_fee_cuttings
  # POST /retired_fee_cuttings.xml
  def create
    @retired_fee_cutting = RetiredFeeCutting.new(params[:retired_fee_cutting])

    respond_to do |format|
      if @retired_fee_cutting.save
        format.html { redirect_to(@retired_fee_cutting) }
        format.xml  { render :xml => @retired_fee_cutting, :status => :created, :location => @retired_fee_cutting }
        format.json { render :text => '{status: "success", message: "成功添加离退休人员扣款！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @retired_fee_cutting.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@retired_fee_cutting.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /retired_fee_cuttings/1
  # PUT /retired_fee_cuttings/1.xml
  def update
    @retired_fee_cutting = RetiredFeeCutting.find(params[:id])

    respond_to do |format|
      if @retired_fee_cutting.update_attributes(params[:retired_fee_cutting])
        format.html { redirect_to(@retired_fee_cutting) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新离退休人员扣款！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @retired_fee_cutting.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@retired_fee_cutting.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /retired_fee_cuttings/1
  # DELETE /retired_fee_cuttings/1.xml
  def destroy
    @retired_fee_cutting = RetiredFeeCutting.find(params[:id])
    @retired_fee_cutting.destroy

    respond_to do |format|
      format.html { redirect_to(retired_fee_cuttings_url) }
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
      joins = "INNER JOIN users p ON retired_fee_cuttings.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @retired_fee_cuttings = RetiredFeeCutting.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = RetiredFeeCutting.count(:joins => joins, :conditions => option_conditions)
    else
      @retired_fee_cuttings = RetiredFeeCutting.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = RetiredFeeCutting.count
    end
    return render_json(@retired_fee_cuttings,count)
  end
end
