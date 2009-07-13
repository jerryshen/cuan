class WelfareBenefitsController < ApplicationController
  protect_from_forgery :except => [:prev, :next, :last]
  # GET /welfare_benefits
  # GET /welfare_benefits.xml
  def index
    @welfare_benefits = WelfareBenefit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @welfare_benefits }
      format.json { render :text => get_json }
      format.csv { export_csv(@welfare_benefits,
          { :id => "id", :user_id => "姓名", :subject => "福利津贴名目", :fee => "金额", :date => "发放时间"}, "福利津贴记录数据.csv") }
    end
  end

  # GET /welfare_benefits/1
  # GET /welfare_benefits/1.xml
  def show
    @welfare_benefit = WelfareBenefit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @welfare_benefit }
    end
  end

  # GET /welfare_benefits/new
  # GET /welfare_benefits/new.xml
  def new
    @welfare_benefit = WelfareBenefit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @welfare_benefit }
    end
  end

  # GET /welfare_benefits/1/edit
  def edit
    @welfare_benefit = WelfareBenefit.find(params[:id])
  end

  def prev
    @welfare_benefit = WelfareBenefit.find(:last, :conditions => ["id < ?", params[:id]], :order => "id ASC")
    if @welfare_benefit
      render :action => "edit"
    else
      render :text => "nodata"
    end
  end

  def next
    @welfare_benefit =  WelfareBenefit.find(:first, :conditions => ["id > ?", params[:id]], :order => "id ASC")
    if @welfare_benefit
      render :action => "edit"
    else
      render :text => "nodata"
    end
  end

  def last
    @welfare_benefit =  WelfareBenefit.last
    if @welfare_benefit
      render :action => "edit"
    else
      render :text => "nodata"
    end
  end

  # POST /welfare_benefits
  # POST /welfare_benefits.xml
  def create
    @welfare_benefit = WelfareBenefit.new(params[:welfare_benefit])

    respond_to do |format|
      if @welfare_benefit.save
        format.html { redirect_to(@welfare_benefit) }
        format.xml  { render :xml => @welfare_benefit, :status => :created, :location => @welfare_benefit }
        format.json { render :text => '{status: "success", message: "成功添加福利津贴！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @welfare_benefit.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@welfare_benefit.errors.full_messages.to_json}}"}
      end
    end
  end

  # PUT /welfare_benefits/1
  # PUT /welfare_benefits/1.xml
  def update
    @welfare_benefit = WelfareBenefit.find(params[:id])

    respond_to do |format|
      if @welfare_benefit.update_attributes(params[:welfare_benefit])
        format.html { redirect_to(@welfare_benefit) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改福利津贴！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @welfare_benefit.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@welfare_benefit.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /welfare_benefits/1
  # DELETE /welfare_benefits/1.xml
  def destroy
    @welfare_benefit = WelfareBenefit.find(params[:id])
    @welfare_benefit.destroy

    respond_to do |format|
      format.html { redirect_to(welfare_benefits_url) }
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
      joins = "INNER JOIN users p ON welfare_benefits.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @welfare_benefits = WelfareBenefit.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = WelfareBenefit.count(:joins => joins, :conditions => option_conditions)
    else
      @welfare_benefits = WelfareBenefit.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = WelfareBenefit.count
    end
    return render_json(@welfare_benefits,count)
  end
end
