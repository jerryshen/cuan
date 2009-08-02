class ScienceBePersonnelsController < ApplicationController
  # GET /science_be_personnels
  # GET /science_be_personnels.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @science_be_personnels }
      format.json { render :text => get_json }
      format.csv { export_csv(@science_be_personnels,
          { :id => "id", :user_id => "姓名", :science_be => "科研津贴", :year => "年度",
            :month => "月份", :date => "发放日期", :is_verified => "是否审核" }, "科研津贴数据.csv") }
    end
  end

  # GET /science_be_personnels/1
  # GET /science_be_personnels/1.xml
  def show
    @science_be_personnel = ScienceBenefit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @science_be_personnel }
    end
  end

  # GET /science_be_personnels/1/edit
  def edit
    @science_be_personnel = ScienceBenefit.find(params[:id])
  end

  # PUT /science_be_personnels/1
  # PUT /science_be_personnels/1.xml
  def update
    @science_be_personnel = ScienceBenefit.find(params[:id])

    respond_to do |format|
      if @science_be_personnel.update_attributes(params[:science_be_personnel])
        format.html { redirect_to(@science_be_personnel) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改科研津贴申请！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @science_be_personnel.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@science_be_personnel.errors.full_messages.to_json}}"}
      end
    end
  end

  # DELETE /science_be_personnels/1
  # DELETE /science_be_personnels/1.xml
  def destroy
    @science_be_personnel = ScienceBenefit.find(params[:id])
    @science_be_personnel.destroy

    respond_to do |format|
      format.html { redirect_to(science_be_personnels_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def verify
    @science_be_personnel = ScienceBenefit.find(params[:id])
    if @science_be_personnel.verify
      render :text =>"true"
    else
      render :text =>"false"
    end
  end

  private
  def get_json
    load_page_data

    conditions = '1=1'
    condition_values = []
    if(!params[:search_name].blank?)
      users = User.find(:all, :conditions => ["name like ?", "%#{params[:search_name]}%"])
      unless users.blank?
        ids = []
        users.each do |u|
          ids.push(u.id)
        end
      else
        ids = []
      end
      idss = ids.join(",")
      conditions += " AND user_id in (#{idss})"
      condition_values << []
    end

    if(!params[:search_verify].blank?)
      value=(params[:search_verify].to_i ==0? false : true)
      conditions += " AND is_verified = ? "
      condition_values << value
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @science_be_personnels = ScienceBenefit.paginate(:order =>"id DESC", :conditions => option_conditions,:per_page=> @pagesize, :page => params[:page] || 1)
      count = ScienceBenefit.count(:conditions => option_conditions)
    else
      @science_be_personnels = ScienceBenefit.paginate(:order =>"id DESC",:per_page=> @pagesize, :page => params[:page] || 1)
      count = ScienceBenefit.count
    end
    return render_json(@science_be_personnels,count)
  end
end
