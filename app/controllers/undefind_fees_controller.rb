class UndefindFeesController < ApplicationController
  # GET /undefind_fees
  # GET /undefind_fees.xml
  def index
    @undefind_fees = UndefindFee.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @undefind_fees }
      format.json { render :text => get_json }
      format.csv { export_csv(@undefind_fees,
          { :id => "id", :user_id => "姓名", :subject => "名目", :fee => "金额",
            :date => "发放日期", :be_type => "类型" }, "不定费用发放数据.csv") }
    end
  end

  # GET /undefind_fees/1
  # GET /undefind_fees/1.xml
  def show
    @undefind_fee = UndefindFee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @undefind_fee }
    end
  end

  # GET /undefind_fees/new
  # GET /undefind_fees/new.xml
  def new
    @undefind_fee = UndefindFee.new
    @departments = Department.all.collect { |d| [d.name, d.id] }

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @undefind_fee }
    end
  end

  # GET /undefind_fees/1/edit
  def edit
    @undefind_fee = UndefindFee.find(params[:id])
  end

  # POST /undefind_fees
  # POST /undefind_fees.xml
  def create
    @undefind_fee = UndefindFee.new(params[:undefind_fee])
    @undefind_fee.user_id = params[:user][:id]

    respond_to do |format|
      if @undefind_fee.save
        format.html { redirect_to(@undefind_fee) }
        format.xml  { render :xml => @undefind_fee, :status => :created, :location => @undefind_fee }
        format.json { render :text => '{status: "success", message: "成功添加不定费用！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @undefind_fee.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@undefind_fee.errors.to_json}}"}
      end
    end
  end

  # PUT /undefind_fees/1
  # PUT /undefind_fees/1.xml
  def update
    @undefind_fee = UndefindFee.find(params[:id])

    respond_to do |format|
      if @undefind_fee.update_attributes(params[:undefind_fee])
        format.html { redirect_to(@undefind_fee) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改不定费用！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @undefind_fee.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@undefind_fee.errors.to_json}}"}
      end
    end
  end

  # DELETE /undefind_fees/1
  # DELETE /undefind_fees/1.xml
  def destroy
    @undefind_fee = UndefindFee.find(params[:id])
    @undefind_fee.destroy

    respond_to do |format|
      format.html { redirect_to(undefind_fees_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end
  
  private
  def get_json
    load_page_data
    if(params[:search_name] && params[:search_name].to_s!='')
      @undefind_fees = UndefindFee.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=> @pagesize,:page => params[:page] || 1)
      count = UndefindFee.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @undefind_fees = UndefindFee.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
      count = UndefindFee.count
    end
    return render_json(@undefind_fees,count)
  end
end
