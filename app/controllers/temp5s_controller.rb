class Temp5sController < ApplicationController

  def index
    @temp5s = Temp5.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @temp5s }
      format.json { render :text => get_json }
    end
  end

  private
  def get_json
    load_page_data
    @temp5s = Temp5.paginate(:order =>"id DESC",:per_page=> @pagesize,:page => params[:page] || 1)
    count = Temp5.count
    return render_json(@temp5s,count)
  end

end
