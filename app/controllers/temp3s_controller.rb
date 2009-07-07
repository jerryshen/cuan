class Temp3sController < ApplicationController

  def index
    @temp3s = Temp3.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @temp3s }
      format.json { render :text => get_json }
    end
  end

  def show
    @temp3 = Temp3.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @temp3 }
    end
  end

  def destroy
    @temp3 = Temp3.find(params[:id])
    @temp3.destroy

    respond_to do |format|
      format.html { redirect_to(temp3s_url) }
      format.xml  { head :ok }
      format.json { render :text => '{status: "success"}'}
    end
  end
  
  private
  def get_json
    load_page_data
    @temp3s = Temp3.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
    count = Temp3.count
    return render_json(@temp3s,count)
  end

end
