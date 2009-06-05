class BankCardsController < ApplicationController
  #  protect_from_forgery :except => :index
  #  skip_before_filter :verify_authenticity_token
  # GET /bank_cards
  # GET /bank_cards.xml
  def index
    @bank_cards = BankCard.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bank_cards }
      format.json { render :text => get_json }
    end
  end

  # GET /bank_cards/1
  # GET /bank_cards/1.xml
  def show
    @bank_card = BankCard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bank_card }
    end
  end

  # GET /bank_cards/new
  # GET /bank_cards/new.xml
  def new
    @bank_card = BankCard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bank_card }
    end
  end

  # GET /bank_cards/1/edit
  def edit
    @bank_card = BankCard.find(params[:id])
  end

  # POST /bank_cards
  # POST /bank_cards.xml
  def create
    @bank_card = BankCard.new(params[:bank_card])

    respond_to do |format|
      if @bank_card.save
        flash[:notice] = 'BankCard was successfully created.'
        format.html { redirect_to(@bank_card) }
        format.xml  { render :xml => @bank_card, :status => :created, :location => @bank_card }
        format.json { render :text => '{status: "success", message: "成功创建银行卡！"}'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bank_card.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@bank_card.errors.to_json}}"}
      end
    end
  end

  # PUT /bank_cards/1
  # PUT /bank_cards/1.xml
  def update
    @bank_card = BankCard.find(params[:id])

    respond_to do |format|
      if @bank_card.update_attributes(params[:bank_card])
        flash[:notice] = 'BankCard was successfully updated.'
        format.html { redirect_to(@bank_card) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新银行卡！"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bank_card.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@bank_card.errors.to_json}}"}
      end
    end
  end

  # DELETE /bank_cards/1
  # DELETE /bank_cards/1.xml
  def destroy
    @bank_card = BankCard.find(params[:id])
    @bank_card.destroy

    respond_to do |format|
      format.html { redirect_to(bank_cards_url) }
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
      @bank_cards = BankCard.paginate(:order =>"id DESC", :conditions => ["name like ?","%#{params[:search_name]}%"],:per_page=>pagesize,:page => params[:page] || 1)
      count = BankCard.count(:conditions =>["name like ?","%#{params[:search_name]}%"])
    else
      @bank_cards = BankCard.paginate(:order =>"id DESC",:per_page=>pagesize,:page => params[:page] || 1)
      count = BankCard.count
    end
    return render_json @bank_cards,count
  end
end
