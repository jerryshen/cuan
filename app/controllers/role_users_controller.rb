class RoleUsersController < ApplicationController
  #  protect_from_forgery :except => :index
  #  skip_before_filter :verify_authenticity_token
  # GET /role_users
  # GET /role_users.xml
  def index
    @role_users = RoleUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @role_users }
      format.json { render :text => get_json }
    end
  end

  # GET /role_users/1
  # GET /role_users/1.xml
  def show
    @role_user = RoleUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @role_user }
    end
  end

  # GET /role_users/new
  # GET /role_users/new.xml
  def new
    @role_user = RoleUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @role_user }
    end
  end

  # GET /role_users/1/edit
  def edit
    @role_user = RoleUser.find(params[:id])
  end

  # POST /role_users
  # POST /role_users.xml
  def create
    @role_user = RoleUser.new(params[:role_user])

    respond_to do |format|
      if @role_user.save
        #        flash[:notice] = 'RoleUser was successfully created.'
        format.html { redirect_to(@role_user) }
        format.xml  { render :xml => @role_user, :status => :created, :location => @role_user }
        format.json { render :text => '{status: "success",message: "成功创建角色－用户关系！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @role_user.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@role_user.errors.to_json}}"}
      end
    end
  end

  # PUT /role_users/1
  # PUT /role_users/1.xml
  def update
    @role_user = RoleUser.find(params[:id])

    respond_to do |format|
      if @role_user.update_attributes(params[:role_user])
        #        flash[:notice] = 'RoleUser was successfully updated.'
        format.html { redirect_to(@role_user) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success",message: "成功更新角色－用户关系！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @role_user.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@role_user.errors.to_json}}"}
      end
    end
  end

  # DELETE /role_users/1
  # DELETE /role_users/1.xml
  def destroy
    @role_user = RoleUser.find(params[:id])
    @role_user.destroy

    respond_to do |format|
      format.html { redirect_to(role_users_url) }
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
      @role_users = RoleUser.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = RoleUser.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @role_users = RoleUser.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = RoleUser.count
    end
    return render_json(@role_users,count)
  end
  
end

