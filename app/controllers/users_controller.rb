class UsersController < ApplicationController
  protect_from_forgery :except => [:update_theme]
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
      format.json { render :text => get_json }
      format.csv { export_csv(@users,{:id => "id",:name => "姓名",:login_id => "账号"},"教职工数据.csv") }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        #        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
        format.json { render :text => '{status: "success", message: "成功创建教职工！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@user.errors.to_json}}"}
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        #        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新教职工！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@user.errors.to_json}}"}
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def update_theme
    if request.post?
      if @current_user.update_theme(params[:theme])
        render :text => "true"
      else
        render :text => "false"
      end
    end
  end

  private
  def get_json
    pagesize = 10
    if(params[:page_size])
      param_pagesize = params[:page_size].to_i
      if param_pagesize > 0 then pagesize = param_pagesize end
    end

    conditions = '1=1'
    condition_values = []
    if(!params[:search_name].blank?)
      conditions += " AND name like ? "
      condition_values << "%#{params[:search_name]}%"
    end

    if(!params[:search_department_id].blank?)
      conditions += " AND department_id = ? "
      condition_values << params[:search_department_id]
    end

    if(!params[:search_title_id].blank?)
      conditions += " AND title_id = ? "
      condition_values << params[:search_title_id]
    end

    if(conditions != '1=1')
      option_conditions = [conditions,condition_values].flatten!
      @users = User.paginate(:order =>"id DESC", :conditions => option_conditions,:per_page=>pagesize, :page => params[:page] || 1)
      count = User.count(:conditions => option_conditions)
    else
      @users = User.paginate(:order =>"id DESC",:per_page=>pagesize, :page => params[:page] || 1)
      count = User.count
    end
    return render_json(@users,count)
  end

end
