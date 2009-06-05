class DepartmentsController < ApplicationController
	#protect_from_forgery :except => :index
  #skip_before_filter :verify_authenticity_token
  # GET /departments
  # GET /departments.xml
  def index
    @departments = Department.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @departments }
      format.json { render :text => get_json }
    end
  end

  # GET /departments/1
  # GET /departments/1.xml
  def show
    @department = Department.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @department }
    end
  end

  # GET /departments/new
  # GET /departments/new.xml
  def new
    @department = Department.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @department }
    end
  end

  # GET /departments/1/edit
  def edit
    @department = Department.find(params[:id])
  end

  # POST /departments
  # POST /departments.xml
  def create
    @department = Department.new(params[:department])

    respond_to do |format|
      if @department.save
#        flash[:notice] = 'Department was successfully created.'
        format.html { redirect_to(@department) }
        format.xml  { render :xml => @department, :status => :created, :location => @department }
        format.json { render :text => '{status: "success", message: "成功创建部门！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @department.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@department.errors.to_json}}"}
      end
    end
  end

  # PUT /departments/1
  # PUT /departments/1.xml
  def update
    @department = Department.find(params[:id])

    respond_to do |format|
      if @department.update_attributes(params[:department])
#        flash[:notice] = 'Department was successfully updated.'
        format.html { redirect_to(@department) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success",message: "成功更新部门！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @department.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@department.errors.to_json}}"}
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.xml
  def destroy
    @department = Department.find(params[:id])
    @department.destroy

    respond_to do |format|
      format.html { redirect_to(departments_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def test
    
  end
  
  private
  def get_json
    pagesize = 10
    if(params[:page_size])
      param_pagesize = params[:page_size].to_i
      if param_pagesize > 0 then pagesize = param_pagesize end
    end
    if(params[:search_name] && params[:search_name].to_s!='')
      @departments = Department.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = Department.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @departments = Department.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = Department.count
    end
    return render_json(@departments,count)
  end
end
