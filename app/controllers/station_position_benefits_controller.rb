class StationPositionBenefitsController < ApplicationController
  protect_from_forgery :except => [:prev, :next, :last]

  def index
    @station_position_benefits = StationPositionBenefit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @station_position_benefits }
      format.json { render :text => get_json }
      format.csv { export_csv(@station_position_benefits,
          { :id => "id", :user_id => "姓名", :station_be => "岗位津贴", :position_be => "职务津贴" }, "岗位－职务津贴数据.csv") }
    end
  end


  def show
    @station_position_benefit = StationPositionBenefit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @station_position_benefit }
    end
  end

  # GET /roles/new
  # GET /roles/new.xml
  def new
    @station_position_benefit = StationPositionBenefit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @station_position_benefit }
    end
  end

  def edit
    @station_position_benefit = StationPositionBenefit.find(params[:id])
  end

  def prev
    @station_position_benefit = StationPositionBenefit.find(:last, :conditions => ["id < ?", params[:id]], :order => "id ASC")
    if @station_position_benefit
      render :action => "edit"
    else
      render :text => "nodata"
    end
  end

  def next
    @station_position_benefit =  StationPositionBenefit.find(:first, :conditions => ["id > ?", params[:id]], :order => "id ASC")
    if @station_position_benefit
      render :action => "edit"
    else
      render :text => "nodata"
    end
  end

  def last
    @station_position_benefit =  StationPositionBenefit.last
    if @station_position_benefit
      render :action => "edit"
    else
      render :text => "nodata"
    end
  end

  def create
    @station_position_benefit = StationPositionBenefit.new(params[:station_position_benefit])

    respond_to do |format|
      if @station_position_benefit.save
        format.html { redirect_to(@station_position_benefit) }
        format.xml  { render :xml => @station_position_benefit, :status => :created, :location => @station_position_benefit }
        format.json { render :text => '{status: "success", message: "成功申请科研津贴！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @station_position_benefit.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@station_position_benefit.errors.full_messages.to_json}}"}
      end
    end
  end

  def update
    @station_position_benefit = StationPositionBenefit.find(params[:id])

    respond_to do |format|
      if @station_position_benefit.update_attributes(params[:station_position_benefit])
        format.html { redirect_to(@station_position_benefit) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新科研津贴！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @station_position_benefit.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@station_position_benefit.errors.full_messages.to_json}}"}
      end
    end
  end

  def destroy
    @station_position_benefit = StationPositionBenefit.find(params[:id])
    @station_position_benefit.destroy

    respond_to do |format|
      format.html { redirect_to(station_position_benefits_url) }
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
      joins = "INNER JOIN users p ON station_position_benefits.user_id=p.id"
      conditions += " AND p.department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @station_position_benefits = StationPositionBenefit.paginate(:order =>"id DESC", :joins => joins , :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = StationPositionBenefit.count(:joins => joins, :conditions => option_conditions)
    else
      @station_position_benefits = StationPositionBenefit.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = StationPositionBenefit.count
    end
    return render_json(@station_position_benefits,count)
  end
end
