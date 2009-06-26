class Temp1sController < ApplicationController

  def index
    @temp1s = Temp1.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @temp1s }
      format.json { render :text => get_json }
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
