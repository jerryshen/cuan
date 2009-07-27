class TotalStatsController < ApplicationController
  # GET /total_stats
  # GET /total_stats.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @total_stats }
    end
  end
end
