class Temp1sController < ApplicationController
 require 'fastercsv'
  def index
    @temp1s = Temp1.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @temp1s }
      format.json { render :text => get_json }
    end
  end

  def show
    @temp1 = Temp1.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @temp1 }
    end
  end

  def edit
    @temp1 = Temp1.find(params[:id])
  end

  def update
    @temp1 = Temp1.find(params[:id])

    respond_to do |format|
      if @temp1.update_attributes(params[:temp1])
        format.html { redirect_to(@temp1) }
        format.xml  { head :ok }
        format.json { render :text => '{status: "success", message: "成功更新记录"}'}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @temp1.errors, :status => :unprocessable_entity }
        format.json { render :text => "{status: 'failed', error:#{@temp1.errors.full_messages.to_json}}"}
      end
    end
  end

  def destroy
    @temp1 = Temp1.find(params[:id])
    @temp1.destroy

    respond_to do |format|
      format.html { redirect_to(temp1s_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end

  def data_ipmort
  end

  def import
    n=0
    FasterCSV.parse(params[:myform][:file])do |row|

      user = User.new
      user.id_card = row[0]
      user.name = row[1].strip
      user.save!
      n=n+1
      GC.start if n%50==0

      flash.now[:notice]="CSV Import Successful, #{n} new records added to data base"
    end
  end

  private
  def get_json
    load_page_data
    @temp1s = Temp1.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
    count = Temp1.count
    return render_json(@temp1s,count)
  end

end
