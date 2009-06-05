class BanksController < ApplicationController
#  protect_from_forgery :except => :index
#  skip_before_filter :verify_authenticity_token
	
  # GET /banks
  # GET /banks.xml
  def index
    @banks = Bank.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @banks }
      format.json { render :text => get_json }
    end
  end

  # GET /banks/1
  # GET /banks/1.xml
  def show
    @bank = Bank.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bank }
    end
  end

  # GET /banks/new
  # GET /banks/new.xml
  def new
    @bank = Bank.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bank }
    end
  end

  # GET /banks/1/edit
  def edit
    @bank = Bank.find(params[:id])
  end

  # POST /banks
  # POST /banks.xml
  def create
    @bank = Bank.new(params[:bank])

    respond_to do |format|
      if @bank.save
        flash[:notice] = 'Bank was successfully created.'
        format.html { redirect_to(@bank) }
        format.xml  { render :xml => @bank, :status => :created, :location => @bank }
        format.json { render :text => '{status: "success", message: "成功创建银行！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bank.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@bank.errors.to_json}}"}
      end
    end
  end

  # PUT /banks/1
  # PUT /banks/1.xml
  def update
    @bank = Bank.find(params[:id])

    respond_to do |format|
      if @bank.update_attributes(params[:bank])
        flash[:notice] = 'Bank was successfully updated.'
        format.html { redirect_to(@bank) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新银行！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bank.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@bank.errors.to_json}}"}
      end
    end
  end

  # DELETE /banks/1
  # DELETE /banks/1.xml
  def destroy
    @bank = Bank.find(params[:id])
    @bank.destroy

    respond_to do |format|
      format.html { redirect_to(banks_url) }
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
      @banks = Bank.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = Bank.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @banks = Bank.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = Bank.count
    end
    return render_json @banks,count
  end

end
