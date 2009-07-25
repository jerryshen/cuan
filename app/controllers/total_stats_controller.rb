class TotalStatsController < ApplicationController
  # GET /total_stats
  # GET /total_stats.xml
  def index
    @total_stats = TotalStat.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @total_stats }
    end
  end

  # GET /total_stats/1
  # GET /total_stats/1.xml
  def show
    @total_stat = TotalStat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @total_stat }
    end
  end

  # GET /total_stats/new
  # GET /total_stats/new.xml
  def new
    @total_stat = TotalStat.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @total_stat }
    end
  end

  # GET /total_stats/1/edit
  def edit
    @total_stat = TotalStat.find(params[:id])
  end

  # POST /total_stats
  # POST /total_stats.xml
  def create
    @total_stat = TotalStat.new(params[:total_stat])

    respond_to do |format|
      if @total_stat.save
        flash[:notice] = 'TotalStat was successfully created.'
        format.html { redirect_to(@total_stat) }
        format.xml  { render :xml => @total_stat, :status => :created, :location => @total_stat }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @total_stat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /total_stats/1
  # PUT /total_stats/1.xml
  def update
    @total_stat = TotalStat.find(params[:id])

    respond_to do |format|
      if @total_stat.update_attributes(params[:total_stat])
        flash[:notice] = 'TotalStat was successfully updated.'
        format.html { redirect_to(@total_stat) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @total_stat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /total_stats/1
  # DELETE /total_stats/1.xml
  def destroy
    @total_stat = TotalStat.find(params[:id])
    @total_stat.destroy

    respond_to do |format|
      format.html { redirect_to(total_stats_url) }
      format.xml  { head :ok }
    end
  end
end
