class WelfareBenefitsController < ApplicationController
  # GET /welfare_benefits
  # GET /welfare_benefits.xml
  def index
    @welfare_benefits = WelfareBenefit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @welfare_benefits }
      format.json { render :text => get_json }
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

  # POST /welfare_benefits
  # POST /welfare_benefits.xml
  def create
    @welfare_benefit = WelfareBenefit.new(params[:welfare_benefit])

    respond_to do |format|
      if @welfare_benefit.save
        #        flash[:notice] = 'WelfareBenefit was successfully created.'
        format.html { redirect_to(@welfare_benefit) }
        format.xml  { render :xml => @welfare_benefit, :status => :created, :location => @welfare_benefit }
        format.json { render :text => '{status: "success", message: "成功添加福利津贴！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @welfare_benefit.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@welfare_benefit.errors.to_json}}"}
      end
    end
  end

  # PUT /welfare_benefits/1
  # PUT /welfare_benefits/1.xml
  def update
    @welfare_benefit = WelfareBenefit.find(params[:id])

    respond_to do |format|
      if @welfare_benefit.update_attributes(params[:welfare_benefit])
        #        flash[:notice] = 'WelfareBenefit was successfully updated.'
        format.html { redirect_to(@welfare_benefit) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改福利津贴！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @welfare_benefit.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@welfare_benefit.errors.to_json}}"}
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
      @welfare_benefits = WelfareBenefit.paginate(:order =>"id DESC", :conditions => ["user_id =?",user_id],:per_page=>pagesize, :page => params[:page] || 1)
      count = @welfare_benefits.length
    elsif(!params[:search_department_id].blank? && params[:search_name].blank?)
      @welfare_benefits = WelfareBenefit.paginate(:order => "id DESC", :joins =>"INNER JOIN users p ON welfare_benefits.user_id=p.id" , :conditions =>["p.department_id =?",params[:search_department_id]],:per_page=>pagesize, :page => params[:page] || 1 )
      count = @welfare_benefits.length
    elsif(!params[:search_department_id].blank? && !params[:search_name].blank?)
      @welfare_benefits = WelfareBenefit.paginate(:order => "id DESC", :joins =>"INNER JOIN users p ON welfare_benefits.user_id=p.id" , :conditions =>["p.department_id =? and p.name like ?",params[:search_department_id],"%#{params[:search_name]}%"],:per_page=>pagesize, :page => params[:page] || 1 )
      count = @welfare_benefits.length
    else
      @welfare_benefits = WelfareBenefit.paginate(:order =>"id DESC",:per_page=>pagesize, :page => params[:page] || 1)
      count = @welfare_benefits.length
    end
    return render_json(@welfare_benefits,count)
  end
end