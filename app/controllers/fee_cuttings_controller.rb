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
#        flash[:notice] = 'FeeCutting was successfully created.'
        format.html { redirect_to(@fee_cutting) }
        format.xml  { render :xml => @fee_cutting, :status => :created, :location => @fee_cutting }
        format.json { render :text => '{status: "success", message: "成功创建扣款！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @fee_cutting.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@fee_cutting.errors.to_json}}"}
      end
    end
  end

  # PUT /fee_cuttings/1
  # PUT /fee_cuttings/1.xml
  def update
    @fee_cutting = FeeCutting.find(params[:id])

    respond_to do |format|
      if @fee_cutting.update_attributes(params[:fee_cutting])
#        flash[:notice] = 'FeeCutting was successfully updated.'
        format.html { redirect_to(@fee_cutting) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新扣款！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fee_cutting.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@fee_cutting.errors.to_json}}"}
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
    pagesize = 10
    if(params[:page_size])
      param_pagesize = params[:page_size].to_i
      if param_pagesize > 0 then pagesize = param_pagesize end
    end

    unless(params[:search_name].blank?)
      if user = User.find_by_name(params[:search_name])
        user_id = user.id
      else
        user_id = 0
      end
      @fee_cuttings = FeeCutting.paginate(:order =>"id DESC", :conditions => ["user_id =?",user_id],:per_page=>pagesize, :page => params[:page] || 1)
      count = @fee_cuttings.length
    end

    unless(params[:search_department_id].blank?)
      @fee_cuttings = FeeCutting.paginate(:order => "id DESC", :joins =>"INNER JOIN users p ON fee_cuttings.user_id=p.id" , :conditions =>["p.department_id =?",params[:search_department_id]],:per_page=>pagesize, :page => params[:page] || 1 )
      count = @fee_cuttings.length
    end

    unless(params[:search_department_id].blank? or params[:search_name].blank?)
      @fee_cuttings = FeeCutting.paginate(:order => "id DESC", :joins =>"INNER JOIN users p ON fee_cuttings.user_id=p.id" , :conditions =>["p.department_id =? and p.name like ?",params[:search_department_id],"%#{params[:search_name]}%"],:per_page=>pagesize, :page => params[:page] || 1 )
      count = @fee_cuttings.length
    else
      @fee_cuttings = FeeCutting.paginate(:order =>"id DESC",:per_page=>pagesize, :page => params[:page] || 1)
      count = FeeCutting.count
    end
    return render_json(@fee_cuttings,count)
  end
end
