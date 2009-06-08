class RetiredBasicSalariesController < ApplicationController
#  protect_from_forgery :except => :index
#  skip_before_filter :verify_authenticity_token
  # GET /retired_basic_salaries
  # GET /retired_basic_salaries.xml
  def index
    @retired_basic_salaries = RetiredBasicSalary.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @retired_basic_salaries }
      format.json { render :text => get_json }
    end
  end

  # GET /retired_basic_salaries/1
  # GET /retired_basic_salaries/1.xml
  def show
    @retired_basic_salary = RetiredBasicSalary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @retired_basic_salary }
    end
  end

  # GET /retired_basic_salaries/new
  # GET /retired_basic_salaries/new.xml
  def new
    @retired_basic_salary = RetiredBasicSalary.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @retired_basic_salary }
    end
  end

  # GET /retired_basic_salaries/1/edit
  def edit
    @retired_basic_salary = RetiredBasicSalary.find(params[:id])
  end

  # POST /retired_basic_salaries
  # POST /retired_basic_salaries.xml
  def create
    @retired_basic_salary = RetiredBasicSalary.new(params[:retired_basic_salary])

    respond_to do |format|
      if @retired_basic_salary.save
#        flash[:notice] = 'RetiredBasicSalary was successfully created.'
        format.html { redirect_to(@retired_basic_salary) }
        format.xml  { render :xml => @retired_basic_salary, :status => :created, :location => @retired_basic_salary }
        format.json { render :text => '{status: "success",message: "成功添加离退休人员基本工资！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @retired_basic_salary.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@retired_basic_salary.errors.to_json}}"}
      end
    end
  end

  # PUT /retired_basic_salaries/1
  # PUT /retired_basic_salaries/1.xml
  def update
    @retired_basic_salary = RetiredBasicSalary.find(params[:id])

    respond_to do |format|
      if @retired_basic_salary.update_attributes(params[:retired_basic_salary])
#        flash[:notice] = 'RetiredBasicSalary was successfully updated.'
        format.html { redirect_to(@retired_basic_salary) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success",message: "成功修改离退休人员基本工资！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @retired_basic_salary.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@retired_basic_salary.errors.to_json}}"}
      end
    end
  end

  # DELETE /retired_basic_salaries/1
  # DELETE /retired_basic_salaries/1.xml
  def destroy
    @retired_basic_salary = RetiredBasicSalary.find(params[:id])
    @retired_basic_salary.destroy

    respond_to do |format|
      format.html { redirect_to(retired_basic_salaries_url) }
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
    if(params[:search_name] && params[:search_name].to_s!='')
      @retired_basic_salaries = RetiredBasicSalary.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = RetiredBasicSalary.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @retired_basic_salaries = RetiredBasicSalary.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = RetiredBasicSalary.count
    end
    return render_json(@retired_basic_salaries,count)
  end

end
