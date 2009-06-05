class PageRolesController < ApplicationController
#	protect_from_forgery :except => :index
#  skip_before_filter :verify_authenticity_token
  # GET /page_roles
  # GET /page_roles.xml
  def index
    @page_roles = PageRole.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @page_roles }
      format.json { render :text => get_json }
    end
  end

  # GET /page_roles/1
  # GET /page_roles/1.xml
  def show
    @page_role = PageRole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page_role }
    end
  end

  # GET /page_roles/new
  # GET /page_roles/new.xml
  def new
    @page_role = PageRole.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page_role }
    end
  end

  # GET /page_roles/1/edit
  def edit
    @page_role = PageRole.find(params[:id])
  end

  # POST /page_roles
  # POST /page_roles.xml
  def create
    @page_role = PageRole.new(params[:page_role])

    respond_to do |format|
      if @page_role.save
        flash[:notice] = 'PageRole was successfully created.'
        format.html { redirect_to(@page_role) }
        format.xml  { render :xml => @page_role, :status => :created, :location => @page_role }
        format.json { render :text => '{status: "success", message: "成功创建页面－角色关系！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page_role.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@page_role.errors.to_json}}"}
      end
    end
  end

  # PUT /page_roles/1
  # PUT /page_roles/1.xml
  def update
    @page_role = PageRole.find(params[:id])

    respond_to do |format|
      if @page_role.update_attributes(params[:page_role])
        flash[:notice] = 'PageRole was successfully updated.'
        format.html { redirect_to(@page_role) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功修改页面－角色关系！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page_role.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@page_role.errors.to_json}}"}
      end
    end
  end

  # DELETE /page_roles/1
  # DELETE /page_roles/1.xml
  def destroy
    @page_role = PageRole.find(params[:id])
    @page_role.destroy

    respond_to do |format|
      format.html { redirect_to(page_roles_url) }
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
      @page_roles = PageRole.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = PageRole.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @page_roles = PageRole.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = PageRole.count
    end
    return render_json @page_roles,count
  end
  
 
end

